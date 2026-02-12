const db = require('../db');

const saveUniversityAssessment = async (req, res) => {
    try {
        const { userId, universityDetails } = req.body;

        const query = `
            INSERT INTO university_assessments (
                user_id, academic_journey, academic_load_label, academic_load_value,
                schedule_control, study_sentiment_rating, primary_help_needed,
                stress_trigger_timing, academic_pressure_response, stress_sources, 
                app_usage_challenges
            ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
            ON CONFLICT (user_id) 
            DO UPDATE SET 
                academic_journey = EXCLUDED.academic_journey,
                academic_load_label = EXCLUDED.academic_load_label,
                academic_load_value = EXCLUDED.academic_load_value,
                schedule_control = EXCLUDED.schedule_control,
                study_sentiment_rating = EXCLUDED.study_sentiment_rating,
                primary_help_needed = EXCLUDED.primary_help_needed,
                stress_trigger_timing = EXCLUDED.stress_trigger_timing,
                academic_pressure_response = EXCLUDED.academic_pressure_response,
                stress_sources = EXCLUDED.stress_sources,
                app_usage_challenges = EXCLUDED.app_usage_challenges,
                updated_at = CURRENT_TIMESTAMP
            RETURNING *;
        `;

        const values = [
            userId,
            universityDetails.academic_journey,
            universityDetails.academic_load_label,
            universityDetails.academic_load_value,
            universityDetails.schedule_control,
            universityDetails.study_sentiment_rating,
            universityDetails.primary_help_needed,
            universityDetails.stress_trigger_timing,
            universityDetails.academic_pressure_response,
            universityDetails.stress_sources,      // Database should be TEXT[]
            universityDetails.app_usage_challenges // Database should be TEXT[]
        ];

        const result = await db.query(query, values);
        res.status(200).json({ success: true, data: result.rows[0] });
    } catch (error) {
        console.error("❌ University Assessment Error:", error);
        res.status(500).json({ error: "Internal server error" });
    }
};

module.exports = { saveUniversityAssessment };