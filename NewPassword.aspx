<%@ Page Title="New Password" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="NewPassword.aspx.cs" Inherits="vivektank1.NewPassword" %>

<%-- New Password - original Figma card design: the second step of the
     password recovery (Forgot Password page comes before it). The user
     types the new password twice and presses Continue; the Login page
     opens next (design flow). No ValidationSummary and no rules panel:
     each validator prints its red message ONLY under the field.
     Database phase: store the new hash with
       UPDATE Users SET PasswordHash = @Password WHERE Email = @Email --%>
<asp:Content ID="NewPasswordContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="auth-wrap">

        <div class="auth-card">

            <h1 class="auth-title">New Password</h1>

            <%-- ========================== NEW PASSWORD ======================== --%>
            <div class="form-group">
                <asp:Label ID="lblNewPassword" runat="server"
                    AssociatedControlID="txtNewPassword"
                    CssClass="form-label"
                    Text="New Password"></asp:Label>

                <asp:TextBox ID="txtNewPassword" runat="server"
                    CssClass="form-control"
                    TextMode="Password"
                    Placeholder="Enter your new password"></asp:TextBox>

                <%-- RequiredFieldValidator - new password must not be empty --%>
                <asp:RequiredFieldValidator ID="rfvNewPassword" runat="server"
                    ControlToValidate="txtNewPassword"
                    ValidationGroup="vgNew"
                    ErrorMessage="Password is required"
                    Text="Password is required"
                    Display="Dynamic"
                    CssClass="field-validator"
                    ForeColor="#DC2626" />

                <%-- RegularExpressionValidator - minimum 8 characters --%>
                <asp:RegularExpressionValidator ID="revNewPassword" runat="server"
                    ControlToValidate="txtNewPassword"
                    ValidationExpression="^.{8,}$"
                    ValidationGroup="vgNew"
                    ErrorMessage="Password must be at least 8 characters"
                    Text="Password must be at least 8 characters"
                    Display="Dynamic"
                    CssClass="field-validator"
                    ForeColor="#DC2626" />
            </div>

            <%-- ======================== CONFIRM PASSWORD ======================= --%>
            <div class="form-group">
                <asp:Label ID="lblConfirmPassword" runat="server"
                    AssociatedControlID="txtConfirmPassword"
                    CssClass="form-label"
                    Text="Confirm Password"></asp:Label>

                <asp:TextBox ID="txtConfirmPassword" runat="server"
                    CssClass="form-control"
                    TextMode="Password"
                    Placeholder="Re-enter your password"></asp:TextBox>

                <%-- RequiredFieldValidator - confirm password must not be empty --%>
                <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server"
                    ControlToValidate="txtConfirmPassword"
                    ValidationGroup="vgNew"
                    ErrorMessage="Confirm Password is required"
                    Text="Confirm Password is required"
                    Display="Dynamic"
                    CssClass="field-validator"
                    ForeColor="#DC2626" />

                <%-- CompareValidator - both passwords must be the same --%>
                <asp:CompareValidator ID="cmpPassword" runat="server"
                    ControlToValidate="txtConfirmPassword"
                    ControlToCompare="txtNewPassword"
                    Operator="Equal"
                    ValidationGroup="vgNew"
                    ErrorMessage="Both password must be same"
                    Text="Both password must be same"
                    Display="Dynamic"
                    CssClass="field-validator"
                    ForeColor="#DC2626" />
            </div>

            <asp:Button ID="btnContinue" runat="server"
                Text="Continue"
                CssClass="btn-block"
                ValidationGroup="vgNew"
                OnClick="btnContinue_Click" />

            <p class="auth-alt">Back to
                <a class="auth-link-strong" href="Login.aspx">Login</a></p>

        </div>

    </div>

</asp:Content>
