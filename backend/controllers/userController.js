// userController.js

const UserServices = require('../services/userService');

// Register
exports.register = async (req, res, next) => {
    try {
        console.log("---req body---", req.body);
        const { email, password } = req.body;

        // Check if user already exists
        const duplicate = await UserServices.getUserByEmail(email);
        if (duplicate) {
            return res.status(400).json({ status: false, message: `User ${email} is already registered` });
        }

        // Register the user
        const response = await UserServices.registerUser(email, password);
        return res.status(201).json({ status: true, success: 'User registered successfully' });

    } catch (err) {
        console.log("---> err -->", err);
        // Pass error to middleware
        next(err);
    }
}

// Login
exports.login = async (req, res, next) => {
    try {
        const { email, password } = req.body;

        // Validate email and password
        if (!email || !password) {
            return res.status(400).json({ status: false, message: 'Email and password are required' });
        }

        // Check if user exists
        let user = await UserServices.checkUser(email);
        if (!user) {
            return res.status(404).json({ status: false, message: 'User does not exist' });
        }

        // Verify password
        const isPasswordCorrect = await user.comparePassword(password);
        if (!isPasswordCorrect) {
            return res.status(401).json({ status: false, message: 'Username or password is incorrect' });
        }

        // Create token
        const tokenData = { _id: user._id, email: user.email };
        const token = await UserServices.generateAccessToken(tokenData, "secret", "1h");

        // Return success with token
        return res.status(200).json({ status: true, success: 'Login successful', token: token });

    } catch (error) {
        console.log(error, 'err---->');
        next(error);  // Pass error to middleware
    }
}

exports.forgotPassword = async (req, res, next) => {
    try {
      const { email } = req.body;
      const user = await UserServices.getUserByEmail(email);
  
      if (!user) {
        return res.status(404).json({ status: false, message: 'User not found' });
      }
  
      const { resetToken, resetTokenHash } = UserServices.generatePasswordResetToken();
      user.passwordResetToken = resetTokenHash;
      user.passwordResetExpires = Date.now() + 10 * 60 * 1000;  // Token valid for 10 minutes
  
      await user.save();  // Save the token and expiration time in the user's record
  
      // Send email with reset link (adjust email service as needed)
      const resetLink = `${req.protocol}://${req.get('host')}/reset-password/${resetToken}`;
      
      await UserServices.sendResetEmail(user.email, resetLink);
  
      res.status(200).json({ status: true, message: 'Password reset link sent to email' });
    } catch (err) {
      console.log(err);
      next(err);
    }
  };
  
  exports.resetPassword = async (req, res, next) => {
    try {
      const { token } = req.params;  // Extract token from URL
      const { password } = req.body;
  
      // Hash the token and compare it to the stored hash
      const hashedToken = crypto.createHash('sha256').update(token).digest('hex');
      const user = await User.findOne({ 
        passwordResetToken: hashedToken, 
        passwordResetExpires: { $gt: Date.now() }  // Check if the token hasn't expired
      });
  
      if (!user) {
        return res.status(400).json({ status: false, message: 'Token is invalid or has expired' });
      }
  
      // Update the user's password and remove the reset token
      user.password = password;  // Make sure to hash the password before saving
      user.passwordResetToken = undefined;
      user.passwordResetExpires = undefined;
  
      await user.save();
  
      res.status(200).json({ status: true, message: 'Password has been updated' });
    } catch (err) {
      console.log(err);
      next(err);
    }
  };
  