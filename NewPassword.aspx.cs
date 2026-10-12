using System;
using System.Web.UI;

namespace vivektank1
{
    /// <summary>
    /// New Password code-behind - second step of the password recovery:
    /// the new password is typed twice (both must match, at least 8
    /// characters) and Continue opens the Login page again (design flow).
    /// The e-mail of the reset step came from the Forgot Password page
    /// through Session["ResetEmail"] (state management).
    /// No ValidationSummary: every validator prints its red message only
    /// under the field.
    /// Database phase: update the Users row with
    ///   UPDATE Users SET PasswordHash = @Password WHERE Email = @Email
    /// </summary>
    public partial class NewPassword : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // For a signed-in user the New Password page makes no sense.
            if (Session["UserId"] != null)
            {
                Response.Redirect("~/Dashboard.aspx");
            }
        }

        /// <summary>
        /// "Continue" button: both password entries valid -> back to the
        /// Login page (the new password is stored in the database phase).
        /// </summary>
        protected void btnContinue_Click(object sender, EventArgs e)
        {
            // Server side validation of both password boxes.
            if (!Page.IsValid)
            {
                return;
            }

            Response.Redirect("~/Login.aspx");
        }
    }
}
