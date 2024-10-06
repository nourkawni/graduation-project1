
const NotesServices = require('../services/NotesService');
const NoteModel = require('../models/NoteModel');
// Register
exports.registerNote = async (req, res, next) => {
    try {
        console.log("---req body---", req.body);
        const { title, text } = req.body;

        const response = await NotesServices.addNote(title, text);
        return res.status(201).json({ status: true, success: 'Note registered successfully' });

    } catch (err) {
        console.log("---> err -->", err);
        // Pass error to middleware
        next(err);
    }
}
exports.addDefaultNote = async (req, res) => {
    try {
        const defaultTitle = "Untitled";
        const defaultText = "Default Text";

        const newNote = await NotesServices.addNote(defaultTitle, defaultText);

        res.status(201).json({ 
            status: true, 
            message: "Note created with default values", 
            note: newNote 
        });
    } catch (err) {
        console.log(err); // Log the error to debug
        res.status(500).json({ status: false, message: "Failed to create note", error: err.message }); // Send back the error message
    }
};

exports.editNote = async (req, res) => {
    try {
        const { id } = req.params;
        const { title, text } = req.body;
        console.log("Updating note with ID:", id);

        const updatedNote = await NoteModel.findByIdAndUpdate(
            id, 
            { title, text }, 
            { new: true }
        );
        if (!updatedNote) {
            return res.status(404).json({ status: false, message: 'Note not found' });
        }
        
        res.status(200).json({ status: true, message: 'Note updated', note: updatedNote });

    } catch (err) {
        console.log(err);
        res.status(500).json({ status: false, message: 'Failed to update note' });
    }
};
