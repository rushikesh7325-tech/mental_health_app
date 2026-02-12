const db = require('./db'); // Path to your db.js

const updateReport = async (refId, newStatus, remarks) => {
    try {
        const query = `
            UPDATE posh_incident_reports 
            SET status = $1, admin_remarks = $2, updated_at = CURRENT_TIMESTAMP 
            WHERE ref_id = $3
            RETURNING *;
        `;
        const result = await db.query(query, [newStatus, remarks, refId]);

        if (result.rowCount > 0) {
            console.log(`✅ SUCCESS: Report ${refId} is now [${newStatus}]`);
            console.table(result.rows[0]);
        } else {
            console.log(`❌ ERROR: No report found with Ref ID: ${refId}`);
        }
    } catch (err) {
        console.error("❌ DB ERROR:", err);
    } finally {
        process.exit();
    }
};

// Get arguments from terminal: node update_status.js <REF_ID> <STATUS> <REMARKS>
const [refId, status, remarks] = process.argv.slice(2);

if (!refId || !status) {
    console.log("Usage: node update_status.js <REF_ID> <STATUS> <REMARKS>");
    console.log("Example: node update_status.js POSH-JLFPQM 'Under Review' 'Looking into evidence'");
    process.exit();
}

updateReport(refId, status, remarks || "No remarks added.");