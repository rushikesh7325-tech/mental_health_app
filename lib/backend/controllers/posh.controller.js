const db = require('../db');
const express = require('express');
const poshController = {    // 1. Finalize Consent (Using UPSERT for safety)
    // posh.controller.js

    async finalizeConsent(req, res) {
        // 1. Log the incoming request to verify the body parser is working
        console.log("Headers received:", req.headers); // Add this to see if Content-Type is there
        console.log("Raw Body:", req.body);
        try {
            // 2. Validate existence before destructuring to prevent the 'undefined' crash
            if (!req.body || Object.keys(req.body).length === 0) {
                console.error("❌ ERROR: req.body is empty or undefined!");
                return res.status(400).json({ error: "No data received by server" });
            }

            const { digitalSignature, timestamp } = req.body;

            // 3. Log the specific extracted values
            console.log(`📝 DEBUG: Extracted Signature: "${digitalSignature}"`);

            const query = `
            INSERT INTO posh_training_compliance (user_id, digital_signature, consent_timestamp, is_acknowledge_accepted)
            VALUES ($1, $2, $3, true)
            ON CONFLICT (user_id) 
            DO UPDATE SET 
                digital_signature = EXCLUDED.digital_signature,
                consent_timestamp = EXCLUDED.consent_timestamp,
                is_acknowledge_accepted = true,
                updated_at = CURRENT_TIMESTAMP
            RETURNING *;
        `;

            const result = await db.query(query, [req.user.id, digitalSignature, timestamp]);
            res.status(200).json({ message: "Consent signed successfully", data: result.rows[0] });
        } catch (err) {
            console.error("❌ Database Error (Consent):", err.message);
            res.status(500).json({ error: "Failed to save digital signature" });
        }
    },
    // 2. Save or Update Training Progress
    async saveTrainingProgress(req, res) {
        const userId = req.user.id; // Corrected: use middleware ID
        const { moduleKey, timeSpent, isComplete } = req.body;

        try {
            const columnMap = {
                'verbal': 'verbal', 'physical': 'physical',
                'digital': 'digital', 'workplace': 'workplace', 'evidence': 'evidence'
            };

            const col = columnMap[moduleKey];
            if (!col) return res.status(400).json({ error: "Invalid module key" });

            const query = `
                INSERT INTO posh_training_compliance (user_id, ${col}_complete, ${col}_time_seconds)
                VALUES ($1, $2, $3)
                ON CONFLICT (user_id) 
                DO UPDATE SET 
                    ${col}_complete = EXCLUDED.${col}_complete,
                    ${col}_time_seconds = posh_training_compliance.${col}_time_seconds + EXCLUDED.${col}_time_seconds,
                    updated_at = CURRENT_TIMESTAMP
                RETURNING *;
            `;

            const result = await db.query(query, [userId, isComplete, timeSpent]);
            res.status(200).json(result.rows[0]);
        } catch (err) {
            console.error("Progress Sync Error:", err);
            res.status(500).json({ error: "Internal server error" });
        }
    },


    // 3. Submit Official Incident Report
    async submitReport(req, res) {
        const userId = req.user.id; // SECURE: Use token ID
        const { meta, details, profile } = req.body;

        try {
            const query = `
                INSERT INTO posh_incident_reports (
                    ref_id, user_id, is_anonymous, reported_by_name, 
                    category, description, incident_occurrence, 
                    location, compliance_sig, training_verified
                ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
                RETURNING ref_id;
            `;

            const values = [
                meta.ref_id,
                userId,
                meta.is_anonymous,
                profile.reported_by,
                details.category,
                details.description,
                details.incident_occurrence,
                details.location,
                meta.compliance_sig,
                profile.training_verified
            ];

            const result = await db.query(query, values);
            res.status(201).json({
                success: true,
                message: "Incident reported successfully",
                referenceId: result.rows[0].ref_id
            });
        } catch (err) {
            console.error("Report Submission Error:", err);
            // Specifically handle Foreign Key violations if the signature is wrong
            if (err.code === '23503') {
                return res.status(400).json({ error: "Signature verification failed. Please complete training first." });
            }
            res.status(500).json({ error: "Failed to submit official report" });
        }
    },
    // posh.controller.js - Add this function
    async getMyReports(req, res) {
        const userId = req.user.id;
        try {
            const query = `
            SELECT ref_id, category, status, admin_remarks, submitted_at 
            FROM posh_incident_reports 
            WHERE user_id = $1 
            ORDER BY submitted_at DESC;
        `;
            const result = await db.query(query, [userId]);
            res.status(200).json(result.rows);
        } catch (err) {
            console.error("Fetch Reports Error:", err);
            res.status(500).json({ error: "Failed to fetch your reports" });
        }
    },
    // posh.controller.js
    async getPoshStatus(req, res) {
        const userId = req.user.id;
        console.log(`🔍 [DEBUG] Fetching POSH status for User: ${userId}`);
        try {
            const training = await db.query(
                'SELECT verbal_complete, physical_complete, digital_complete, workplace_complete, evidence_complete FROM posh_training_compliance WHERE user_id = $1',
                [userId]
            );

            const reports = await db.query(
                'SELECT ref_id, status FROM posh_incident_reports WHERE user_id = $1 ORDER BY submitted_at DESC LIMIT 1',
                [userId]
            );

            console.log(`✅ [DEBUG] Training Found: ${training.rows.length > 0}, Reports Found: ${reports.rows.length}`);

            res.status(200).json({
                trainingComplete: training.rows.length > 0 && Object.values(training.rows[0]).every(v => v === true),
                report: reports.rows[0] || null
            });
        } catch (err) {
            console.error("❌ [DEBUG] Status Error:", err);
            res.status(500).json({ error: "DB Error" });
        }
    }
};

module.exports = poshController;