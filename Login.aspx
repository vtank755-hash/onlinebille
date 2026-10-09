<%@ Page Title="Login" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="vivektank1.Login" %>

<%-- Login page - original Figma card design.
     Every input is checked with ASP.NET Validation Controls (no custom
     JavaScript). The error message is shown ONLY in red, directly under its
     own field - no summary box anywhere else on the page. --%>
<asp:Content ID="LoginContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="auth-wrap">

        <div class="auth-card">

            <h1 class="auth-title">User Login</h1>
            <p class="auth-subtitle">Access your personalized billing panel</p>

            <%-- No ValidationSummary and no rules panel: each validator prints
                 its own message under its own field only. --%>

            <div class="form-group">
                <asp:Label ID="lblEmail" runat="server"
                    AssociatedControlID="txtEmail"
                    CssClass="form-label"
                    Text="Email Address"></asp:Label>

                <asp:TextBox ID="txtEmail" runat="server"
                    CssClass="form-control"
                    TextMode="Email"
                    Placeholder="Enter your email address"></asp:TextBox>

                <%-- RequiredFieldValidator - e-mail must not be empty --%>
                <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
                    ControlToValidate="txtEmail"
                    ValidationGroup="vgLogin"
                    ErrorMessage="E-mail is required."
                    Text="E-mail is required."
                    Display="Dynamic"
                    CssClass="field-validator"
                    ForeColor="#DC2626" />

                <%-- RegularExpressionValidator - e-mail format --%>
                <asp:RegularExpressionValidator ID="revEmail" runat="server"
                    ControlToValidate="txtEmail"
                    ValidationExpression="^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$"
                    ValidationGroup="vgLogin"
                    ErrorMessage="You must enter the valid Email Id"
                    Text="You must enter the valid Email Id"
                    Display="Dynamic"
                    CssClass="field-validator"
                    ForeColor="#DC2626" />
            </div>

            <div class="form-group">
                <asp:Label ID="lblPassword" runat="server"
                    AssociatedControlID="txtPassword"
                    CssClass="form-label"
                    Text="Password"></asp:Label>

                <asp:TextBox ID="txtPassword" runat="server"
                    CssClass="form-control"
                    TextMode="Password"
                    Placeholder="Enter your password"></asp:TextBox>

                <%-- RequiredFieldValidator - password must not be empty --%>
                <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                    ControlToValidate="txtPassword"
                    ValidationGroup="vgLogin"
                    ErrorMessage="Password is required"
                    Text="Password is required"
                    Display="Dynamic"
                    CssClass="field-validator"
                    ForeColor="#DC2626" />

                <%-- RegularExpressionValidator - minimum 8 characters --%>
                <asp:RegularExpressionValidator ID="revPassword" runat="server"
                    ControlToValidate="txtPassword"
                    ValidationExpression="^.{8,}$"
                    ValidationGroup="vgLogin"
                    ErrorMessage="Password must be at least 8 characters"
                    Text="Password must be at least 8 characters"
                    Display="Dynamic"
                    CssClass="field-validator"
                    ForeColor="#DC2626" />
            </div>

            <div class="form-row">
                <asp:CheckBox ID="chkRemember" runat="server"
                    Text="Remember Me"
                    CssClass="remember-check" />
                <a class="auth-link" href="#" title="Password recovery is not part of this project scope">Forgot Password?</a>
            </div>

            <asp:Button ID="btnLogin" runat="server"
                Text="Login"
                CssClass="btn-block"
                ValidationGroup="vgLogin"
                OnClick="btnLogin_Click" />

            <p class="auth-alt">Register Here
                <a class="auth-link-strong" href="Register.aspx">Register Here</a></p>

        </div>

    </div>

</asp:Content>
