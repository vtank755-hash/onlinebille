using System;
using System.Web.UI;

namespace vivektank1
{
    /// <summary>
    /// Forgot Password code-behind - the user enters the e-mail address
    /// and presses the button; the New Password page opens next (design
    /// flow). The entered e-mail is kept in the Session for that step
    /// (state management). No ValidationSummary: every validator prints
    /// its red message only under the e-mail field.
    /// Database phase: check the e-mail against the Users table with
    ///   SELECT COUNT(*) FROM Users WHERE Email = @Email
    /// before the page opens the New Password step.
    /// </summary>
    public partial class ForgotPassword : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // For a signed-in user the Forgot Password page makes no sense.
            if (Session["UserId"] != null)
            {
                Response.Redirect("~/Dashboard.aspx");
            }
        }

        /// <summary>
        /// "Forgot Password" button: valid e-mail -> keep it in the
        /// Session and open the New Password page.
        /// </summary>
        protected void btnForgotPassword_Click(object sender, EventArgs e)
        {
            // Server side validation of the e-mail (the red messages of
            // the two validators print themselves under the field).
            if (!Page.IsValid)
            {
                return;
            }

            // E-mail of the reset step (shown by the database phase).
            Session["ResetEmail"] = txtEmail.Text.Trim();

            Response.Redirect("~/NewPassword.aspx");
        }
    }
}
