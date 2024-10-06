const mongoose = require('mongoose');
const db = require("../config/database");

const { Schema } = mongoose;
const noteSchema =new Schema({
    title: {
      type: String,
      required: true,
    },
    text: {
      type: String,
      required: true,
    }
  });
  const NoteModel = db.model('Note',noteSchema);
  module.exports = NoteModel;