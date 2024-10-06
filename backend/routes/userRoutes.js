const router = require("express").Router();
const UserController = require('../controllers/userController');
const NoteController = require('../controllers/NoteController');

router.post("/register",UserController.register);
router.post("/login", UserController.login);
router.post("/forgot-password", UserController.forgotPassword);

router.post("/AddNote",NoteController.registerNote);
router.post("/add-default-note", NoteController.addDefaultNote);
router.put("/edit-note/:id", NoteController.editNote);
router.put("/push-note/:userId", UserController.pushNote);
module.exports = router;