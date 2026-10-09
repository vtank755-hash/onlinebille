using System;
using System.Web.UI;

namespace vivektank1
{
    /// <summary>
    /// Register page code-behind.
    /// Uses ASP.NET Validation Controls (RequiredFieldValidator,
    /// RegularExpressionValidator and CompareValidator) for input checking.
    /// Saving the new user with ADO.NET is wired up in the database phase.
    /// </summary>
    public partial class Register : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Server-side state management: an already signed-in user is
            // sent straight to the dashboard.
            if (!IsPostBack && Session["UserId"] != null)
            {
                Response.Redirect("~/Dashboard.aspx");
            }
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            // All validators of the "vgRegister" group have already run on the
            // client and on the server; wrong input is marked red under its
            // own field. No message box is shown anywhere on the page.
            if (!Page.IsValid)
            {
                return;
            }

            // ------------------------------------------------------------------
            // Next step (database phase): ADO.NET disconnected model
            //   SqlDataAdapter / DataSet or SqlCommand INSERT
            //   INSERT INTO Users (FullName, Email, Mobile, Password)
            //   VALUES (@name, @email, @mobile, @pwd)
            // ------------------------------------------------------------------
            // Registration accepted -> straight to the Login page (no box).
            Response.Redirect("~/Login.aspx");
        }
    }
}
