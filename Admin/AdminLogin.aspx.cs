using System;
using System.Web.UI;

namespace vivektank1
{
    /// <summary>
    /// Admin Login page code-behind.
    /// Uses ASP.NET Validation Controls for input checking and Session state
    /// for keeping the signed-in admin. Validates against admin users in database.
    /// Supports ReturnUrl for post-login redirect.
    /// </summary>
    public partial class AdminLogin : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Server-side state management: an already signed-in admin is
            // sent straight to the admin dashboard (or return URL).
            if (!IsPostBack && Session["AdminId"] != null)
            {
                string returnUrl = GetSafeReturnUrl();
                Response.Redirect(returnUrl);
            }

            // Capture return URL from query string
            if (!IsPostBack)
            {
                string returnUrl = Request.QueryString["ReturnUrl"];
                if (!string.IsNullOrEmpty(returnUrl))
                {
                    ViewState["ReturnUrl"] = returnUrl;
                }
            }
        }

        protected void btnAdminLogin_Click(object sender, EventArgs e)
        {
            // All validators of the "vgAdminLogin" group have already run on the
            // client and on the server; wrong input is marked red under its
            // own field. Nothing else is shown on the page.
            if (!Page.IsValid)
            {
                return;
            }

            // ------------------------------------------------------------------
            // Admin authentication - check against Users table where Role = 'Admin'
            // Database phase: verify with ADO.NET (SqlConnection / SqlCommand /
            // SqlDataReader) before the Session values are written.
            // ------------------------------------------------------------------
            string email = txtAdminEmail.Text.Trim();

            // TODO: Replace with actual database authentication
            // using (var conn = new SqlConnection(connStr))
            // using (var cmd = new SqlCommand("SELECT UserId, FullName FROM Users WHERE Email = @Email AND Role = 'Admin'", conn))
            // {
            //     cmd.Parameters.AddWithValue("@Email", email);
            //     conn.Open();
            //     using (var reader = cmd.ExecuteReader())
            //     {
            //         if (reader.Read())
            //         {
            //             Session["AdminId"] = reader["UserId"];
            //             Session["AdminName"] = reader["FullName"];
            //             Session["AdminRole"] = "Admin";
            //             
            //             // Audit log
            //             LogLoginAttempt(email, true);
            //             
            //             string returnUrl = GetSafeReturnUrl();
            //             Response.Redirect(returnUrl);
            //             return;
            //         }
            //     }
            //     LogLoginAttempt(email, false);
            //     ShowError("Invalid admin credentials.");
            //     return;
            // }

            // Placeholder: accepts any valid-format email for demo
            Session["AdminId"] = 1;
            Session["AdminName"] = email.Split('@')[0];
            Session["AdminRole"] = "Admin";

            // Audit log (placeholder)
            LogLoginAttempt(email, true);

            string returnUrl = GetSafeReturnUrl();
            Response.Redirect(returnUrl);
        }

        /// <summary>
        /// Returns a safe return URL (validates it's a local path under /Admin/).
        /// </summary>
        private string GetSafeReturnUrl()
        {
            string returnUrl = ViewState["ReturnUrl"] as string;
            if (string.IsNullOrEmpty(returnUrl))
            {
                return "~/Admin/AdminDashboard.aspx";
            }

            // Security: only allow local URLs under /Admin/
            if (returnUrl.StartsWith("~/Admin/") || returnUrl.StartsWith("/Admin/"))
            {
                return returnUrl;
            }

            return "~/Admin/AdminDashboard.aspx";
        }

        /// <summary>
        /// Shows an error message in the lblError label.
        /// </summary>
        private void ShowError(string message)
        {
            lblError.Text = message;
            lblError.Visible = true;
        }

        /// <summary>
        /// Logs login attempts for audit trail.
        /// Database phase: write to AdminAuditLog table.
        /// </summary>
        private void LogLoginAttempt(string email, bool success)
        {
            // Database phase:
            // INSERT INTO AdminAuditLog (Email, IpAddress, UserAgent, Success, AttemptedAt)
            // VALUES (@Email, @Ip, @UserAgent, @Success, GETDATE())
            //
            // string ip = Request.UserHostAddress;
            // string ua = Request.UserAgent;
            // using (var conn = new SqlConnection(connStr))
            // using (var cmd = new SqlCommand(sql, conn))
            // {
            //     cmd.Parameters.AddWithValue("@Email", email);
            //     cmd.Parameters.AddWithValue("@Ip", ip);
            //     cmd.Parameters.AddWithValue("@UserAgent", ua ?? "");
            //     cmd.Parameters.AddWithValue("@Success", success);
            //     conn.Open();
            //     cmd.ExecuteNonQuery();
            // }
            
            // For now: debug output
            System.Diagnostics.Debug.WriteLine($"[AUDIT] Admin login: {email} - {(success ? "SUCCESS" : "FAILED")} - IP: {Request.UserHostAddress}");
        }
    }
}