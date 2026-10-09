using System;
using System.Web.UI;

namespace vivektank1
{
    /// <summary>
    /// Login page code-behind.
    /// Uses ASP.NET Validation Controls for input checking and Session state
    /// for keeping the signed-in user. ADO.NET authentication against the
    /// SQL Server Users table is wired up in the database phase.
    /// </summary>
    public partial class Login : Page
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

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            // All validators of the "vgLogin" group have already run on the
            // client and on the server; wrong input is marked red under its
            // own field. Nothing else is shown on the page.
            if (!Page.IsValid)
            {
                return;
            }

            // ------------------------------------------------------------------
            // Until the database phase this accepts any valid-format e-mail.
            // In the database phase the same block is verified against the
            // Users table with ADO.NET (SqlConnection / SqlCommand /
            // SqlDataReader) before the Session values are written.
            // ------------------------------------------------------------------
            string email = txtEmail.Text.Trim();

            // Server-side state management: remember the signed-in user and
            // open the dashboard page.
            Session["UserId"] = 1;                             // placeholder id
            Session["UserName"] = email.Split('@')[0];         // e.g. "student"
            Session["Role"] = "Admin";

            Response.Redirect("~/Dashboard.aspx");
        }
    }
}
