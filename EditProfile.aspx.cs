using System;
using System.Web.UI;

namespace vivektank1
{
    /// <summary>
    /// Edit Profile code-behind - STATIC page in this stage: the form
    /// shows the three boxes of the Personal Information card (Full
    /// Name, Email Address, Phone Number) and the Save Changes /
    /// Change Photo / Remove buttons exactly as the Figma design, but
    /// nothing is saved here. The page only keeps the signed-in state
    /// management and marks the Profile item of the sidebar as active.
    /// Database phase: fill the boxes from the Users table with ADO.NET
    ///   SELECT FullName, Email, Phone FROM Users WHERE Email = @Email
    /// and save them on the Save Changes button with
    ///   UPDATE Users SET FullName = @name, Email = @email, Phone = @phone
    /// </summary>
    public partial class EditProfile : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // State management: only for a signed-in user.
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            // Edit Profile page of the sidebar.
            DashboardMaster shell = (DashboardMaster)Master;
            shell.ActivateNav("Profile");
        }
    }
}