<%@ Page Title="Admin Login" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AdminLogin.aspx.cs" Inherits="vivektank1.AdminLogin" %>

<%-- Admin Login page - separate from User Login.
     Uses the Admin Master Page with magenta accent theme.
     Validates admin credentials and redirects to Admin Dashboard.
     Every input is checked with ASP.NET Validation Controls (no custom
     JavaScript). The error message is shown ONLY in red, directly under its
     own field - no summary box anywhere else on the page. --%>
<asp:Content ID="AdminLoginContent" ContentPlaceHolderID="AdminContent" runat="server">

    <div class="auth-wrap">

        <div class="auth-card auth-card-admin">

            <div class="auth-admin-badge">
                <span class="admin-badge-icon">
                    <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                        <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8zm-1-13h2v6h-2zm0 8h2v2h-2z" fill="#C2185B"/>
                    </svg>
                </span>
                <span class="admin-badge-text">ADMIN ACCESS</span>
            </div>

            <h1 class="auth-title">Admin Login</h1>
            <p class="auth-subtitle">Enter your admin credentials to access the admin panel</p>

            <%-- No ValidationSummary and no rules panel: each validator prints
                 its own message under its own field only. --%>

            <div class="form-group">
                <asp:Label ID="lblAdminEmail" runat="server"
                    AssociatedControlID="txtAdminEmail"
                    CssClass="form-label"
                    Text="Admin Email Address"></asp:Label>

                <asp:TextBox ID="txtAdminEmail" runat="server"
                    CssClass="form-control"
                    TextMode="Email"
                    Placeholder="Enter admin email address"></asp:TextBox>

                <%-- RequiredFieldValidator - e-mail must not be empty --%>
                <asp:RequiredFieldValidator ID="rfvAdminEmail" runat="server"
                    ControlToValidate="txtAdminEmail"
                    ValidationGroup="vgAdminLogin"
                    ErrorMessage="E-mail is required."
                    Text="E-mail is required."
                    Display="Dynamic"
                    CssClass="field-validator"
                    ForeColor="#DC2626" />

                <%-- RegularExpressionValidator - e-mail format --%>
                <asp:RegularExpressionValidator ID="revAdminEmail" runat="server"
                    ControlToValidate="txtAdminEmail"
                    ValidationExpression="^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$"
                    ValidationGroup="vgAdminLogin"
                    ErrorMessage="You must enter the valid Email Id"
                    Text="You must enter the valid Email Id"
                    Display="Dynamic"
                    CssClass="field-validator"
                    ForeColor="#DC2626" />
            </div>

            <div class="form-group">
                <asp:Label ID="lblAdminPassword" runat="server"
                    AssociatedControlID="txtAdminPassword"
                    CssClass="form-label"
                    Text="Admin Password"></asp:Label>

                <asp:TextBox ID="txtAdminPassword" runat="server"
                    CssClass="form-control"
                    TextMode="Password"
                    Placeholder="Enter admin password"></asp:TextBox>

                <%-- RequiredFieldValidator - password must not be empty --%>
                <asp:RequiredFieldValidator ID="rfvAdminPassword" runat="server"
                    ControlToValidate="txtAdminPassword"
                    ValidationGroup="vgAdminLogin"
                    ErrorMessage="Password is required"
                    Text="Password is required"
                    Display="Dynamic"
                    CssClass="field-validator"
                    ForeColor="#DC2626" />

                <%-- RegularExpressionValidator - minimum 8 characters --%>
                <asp:RegularExpressionValidator ID="revAdminPassword" runat="server"
                    ControlToValidate="txtAdminPassword"
                    ValidationExpression="^.{8,}$"
                    ValidationGroup="vgAdminLogin"
                    ErrorMessage="Password must be at least 8 characters"
                    Text="Password must be at least 8 characters"
                    Display="Dynamic"
                    CssClass="field-validator"
                    ForeColor="#DC2626" />
            </div>

            <div class="form-row">
                <asp:CheckBox ID="chkAdminRemember" runat="server"
                    Text="Remember Me"
                    CssClass="remember-check" />
            </div>

            <asp:Button ID="btnAdminLogin" runat="server"
                Text="Sign In"
                CssClass="btn-block btn-admin"
                ValidationGroup="vgAdminLogin"
                OnClick="btnAdminLogin_Click" />

            <div class="auth-links">
                <a class="auth-link" href="AdminForgotPassword.aspx">Forgot Password?</a>
                <span class="auth-separator">|</span>
                <a class="auth-link" href="../Login.aspx">Back to User Login</a>
            </div>

            <asp:Label ID="lblError" runat="server" CssClass="auth-error" Visible="false" EnableViewState="false"></asp:Label>

        </div>

    </div>

</asp:Content>