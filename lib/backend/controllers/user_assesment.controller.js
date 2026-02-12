const db = require('../db'); // Your database connection
const saveAssessment = async (req, res) => {
    try {
        const { userId, responses } = req.body;

        // Map the Flutter IDs to Database Columns
        const assessmentData = {
            user_id: userId,
            mood_state: responses[2],
            primary_challenges: responses[3], // Expecting Array
            coping_mechanisms: JSON.stringify(responses[4]), // Map -> JSONB
            support_level_score: parseInt(responses[5]),
            sleep_patterns: JSON.stringify(responses[6]), // Map -> JSONB
            physical_activity_frequency: responses[7],
            mindfulness_routine: JSON.stringify(responses[8]), // Map -> JSONB
            stress_sources: responses[9], // Expecting Array
            stress_locations: responses[10], // Expecting Array
            barriers_to_entry: responses[11], // Expecting Array
            learning_preferences: JSON.stringify(responses[12]), // Map -> JSONB
            weekly_commitment: responses[13],
            open_reflection: responses[14],
            selected_insights: responses[15] // Expecting Array
        };

        const query = `
            INSERT INTO user_assessments (
                user_id, mood_state, primary_challenges, coping_mechanisms, 
                support_level_score, sleep_patterns, physical_activity_frequency, 
                mindfulness_routine, stress_sources, stress_locations, 
                barriers_to_entry, learning_preferences, weekly_commitment, 
                open_reflection, selected_insights
            ) VALUES (
                $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15
            ) RETURNING *;
        `;

        const values = Object.values(assessmentData);
        const result = await db.query(query, values);

        res.status(201).json({
            success: true,
            message: "Assessment saved successfully",
            data: result.rows[0]
        });

    } catch (error) {
        console.error("Error saving assessment:", error);
        res.status(500).json({
            success: false,
            message: "Internal server error"
        });
    }
};
module.exports = { saveAssessment };