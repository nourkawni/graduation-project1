const NoteModel = require("../models/NoteModel");
class NotesServices{
 
    static async addNote(title,text){
        try{
                console.log("-----title --- text-----",title,text);
                
                const createNote = new NoteModel({title,text});
                return await createNote.save();
        }catch(err){
            throw err;
        }
    }
}
module.exports = NotesServices;