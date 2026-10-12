<%@ Page Title="Forgot Password" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ForgotPassword.aspx.cs" Inherits="vivektank1.ForgotPassword" %>

<%-- Forgot Password - original Figma card design: the user enters the
     e-mail address and presses the button; the page then opens the
     New Password page (design flow). The e-mail is kept in the Session
     (state management) for that step. No ValidationSummary and no rules
     panel: each validator prints its red message ONLY under the field.
     Database phase: check the e-mail with
       SELECT COUNT(*) FROM Users WHERE Email = @Email --%>
<asp:Content ID="ForgotPasswordContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="auth-wrap">

        <div class="auth-card">

            <h1 class="auth-title">Forgot Password</h1>

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
                    ValidationGroup="vgForgot"
                    ErrorMessage="E-mail is required."
                    Text="E-mail is required."
                    Display="Dynamic"
                    CssClass="field-validator"
                    ForeColor="#DC2626" />

                <%-- RegularExpressionValidator - e-mail format --%>
                <asp:RegularExpressionValidator ID="revEmail" runat="server"
                    ControlToValidate="txtEmail"
                    ValidationExpression="^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$"
                    ValidationGroup="vgForgot"
                    ErrorMessage="You must enter the valid Email Id"
                    Text="You must enter the valid Email Id"
                    Display="Dynamic"
                    CssClass="field-validator"
                    ForeColor="#DC2626" />
            </div>

            <asp:Button ID="btnForgotPassword" runat="server"
                Text="Forgot Password"
                CssClass="btn-block"
                ValidationGroup="vgForgot"
                OnClick="btnForgotPassword_Click" />

            <p class="auth-alt">Back to
                <a class="auth-link-strong" href="Login.aspx">Login</a></p>

        </div>

    </div>

</asp:Content>
