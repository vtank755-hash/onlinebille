<%@ Page Title="Register" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="vivektank1.Register" %>

<%-- Register page - User Registration card (same design as the Login page).
     Every input is guarded by an ASP.NET Validation Control (no custom
     JavaScript). Each validator prints its own red message ONLY under its
     own field - there is no ValidationSummary box anywhere on this page.

     Validation rules applied here:
       1. Full Name        - required
       2. E-mail           - required + valid Email Id format
       3. Mobile Number    - required + exactly 10 digits
       4. Password         - required + minimum 8 characters
       5. Confirm Password - required + must be same as Password (CompareValidator)
--%>
<asp:Content ID="RegisterContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="auth-wrap">

        <div class="auth-card auth-card-register">

            <h1 class="auth-title">User Registration</h1>
            <p class="auth-subtitle">Create an account to start managing invoices</p>

            <%-- ============================ FULL NAME =========================== --%>
            <div class="form-group">
                <asp:Label ID="lblFullName" runat="server"
                    AssociatedControlID="txtFullName"
                    CssClass="form-label"
                    Text="Full Name"></asp:Label>

                <asp:TextBox ID="txtFullName" runat="server"
                    CssClass="form-control"
                    Placeholder="Enter your full name"></asp:TextBox>

                <%-- RequiredFieldValidator - full name must not be empty --%>
                <asp:RequiredFieldValidator ID="rfvFullName" runat="server"
                    ControlToValidate="txtFullName"
                    ValidationGroup="vgRegister"
                    ErrorMessage="Full Name is required."
                    Text="Full Name is required."
                    Display="Dynamic"
                    CssClass="field-validator"
                    ForeColor="#DC2626" />
            </div>

            <%-- ============================= E-MAIL ============================ --%>
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
                    ValidationGroup="vgRegister"
                    ErrorMessage="E-mail is required."
                    Text="E-mail is required."
                    Display="Dynamic"
                    CssClass="field-validator"
                    ForeColor="#DC2626" />

                <%-- RegularExpressionValidator - e-mail format --%>
                <asp:RegularExpressionValidator ID="revEmail" runat="server"
                    ControlToValidate="txtEmail"
                    ValidationExpression="^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$"
                    ValidationGroup="vgRegister"
                    ErrorMessage="You must enter the valid Email Id"
                    Text="You must enter the valid Email Id"
                    Display="Dynamic"
                    CssClass="field-validator"
                    ForeColor="#DC2626" />
            </div>

            <%-- ========================== MOBILE NUMBER ========================= --%>
            <div class="form-group">
                <asp:Label ID="lblMobile" runat="server"
                    AssociatedControlID="txtMobile"
                    CssClass="form-label"
                    Text="Mobile Number"></asp:Label>

                <asp:TextBox ID="txtMobile" runat="server"
                    CssClass="form-control"
                    MaxLength="10"
                    Placeholder="Enter 10-digit mobile number"></asp:TextBox>

                <%-- RequiredFieldValidator - mobile number must not be empty --%>
                <asp:RequiredFieldValidator ID="rfvMobile" runat="server"
                    ControlToValidate="txtMobile"
                    ValidationGroup="vgRegister"
                    ErrorMessage="Mobile Number is required"
                    Text="Mobile Number is required"
                    Display="Dynamic"
                    CssClass="field-validator"
                    ForeColor="#DC2626" />

                <%-- RegularExpressionValidator - exactly 10 digits --%>
                <asp:RegularExpressionValidator ID="revMobile" runat="server"
                    ControlToValidate="txtMobile"
                    ValidationExpression="^[0-9]{10}$"
                    ValidationGroup="vgRegister"
                    ErrorMessage="Mobile Number must be 10 digits"
                    Text="Mobile Number must be 10 digits"
                    Display="Dynamic"
                    CssClass="field-validator"
                    ForeColor="#DC2626" />
            </div>

            <%-- ============================ PASSWORD =========================== --%>
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
                    ValidationGroup="vgRegister"
                    ErrorMessage="Password is required"
                    Text="Password is required"
                    Display="Dynamic"
                    CssClass="field-validator"
                    ForeColor="#DC2626" />

                <%-- RegularExpressionValidator - minimum 8 characters --%>
                <asp:RegularExpressionValidator ID="revPassword" runat="server"
                    ControlToValidate="txtPassword"
                    ValidationExpression="^.{8,}$"
                    ValidationGroup="vgRegister"
                    ErrorMessage="Password must be at least 8 characters"
                    Text="Password must be at least 8 characters"
                    Display="Dynamic"
                    CssClass="field-validator"
                    ForeColor="#DC2626" />
            </div>

            <%-- ========================= CONFIRM PASSWORD ======================= --%>
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
                    ValidationGroup="vgRegister"
                    ErrorMessage="Confirm Password is required"
                    Text="Confirm Password is required"
                    Display="Dynamic"
                    CssClass="field-validator"
                    ForeColor="#DC2626" />

                <%-- CompareValidator - both passwords must be the same --%>
                <asp:CompareValidator ID="cmpPassword" runat="server"
                    ControlToValidate="txtConfirmPassword"
                    ControlToCompare="txtPassword"
                    Operator="Equal"
                    Type="String"
                    ValidationGroup="vgRegister"
                    ErrorMessage="Both password must be same"
                    Text="Both password must be same"
                    Display="Dynamic"
                    CssClass="field-validator"
                    ForeColor="#DC2626" />
            </div>

            <asp:Button ID="btnRegister" runat="server"
                Text="Register"
                CssClass="btn-block"
                ValidationGroup="vgRegister"
                OnClick="btnRegister_Click" />

            <p class="auth-alt">Already have an account?
                <a class="auth-link-strong" href="Login.aspx">Login</a></p>

        </div>

    </div>

</asp:Content>
