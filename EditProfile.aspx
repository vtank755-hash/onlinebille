<%@ Page Title="Edit Profile" Language="C#" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" CodeBehind="EditProfile.aspx.cs" Inherits="vivektank1.EditProfile" %>

<%-- Edit Profile - original Figma card design (Profile.aspx shows the same
     profile read only; this page is the edit form of the design).
     STATIC page in this stage: the three boxes of the Personal
     Information card (Full Name, Email Address, Phone Number) and the
     Save Changes / Change Photo / Remove buttons are display only -
     nothing is saved here, no field or button was removed.
     Database phase: fill the boxes from the Users table with ADO.NET
     (SELECT * FROM Users WHERE Email = @Email) and save with
       UPDATE Users SET FullName = @name, Email = @email, Phone = @phone ... --%>
<asp:Content ID="ProfileHeaderTitle" ContentPlaceHolderID="DashHeaderTitle" runat="server">Edit Profile</asp:Content>

<asp:Content ID="ProfileBody" ContentPlaceHolderID="DashContent" runat="server">

    <%-- ======================= TITLE + SAVE BUTTON ====================== --%>
    <div class="pf-head">

        <div>
            <h2 class="pf-title">Profile Settings</h2>
            <p class="pf-sub">Manage your personal information and preferences.</p>
        </div>

        <%-- Static button of the design (display only - nothing is saved). --%>
        <button type="button" class="pf-save">Save Changes</button>
    </div>

    <%-- ============================= PHOTO CARD ========================== --%>
    <div class="pf-card">
        <div class="pf-photo-row">

            <span class="pf-photo">
                <svg viewBox="0 0 40 40" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                    <circle cx="20" cy="20" r="20" fill="#DBE3FF" />
                    <circle cx="20" cy="15.5" r="6.6" fill="#5B6BD6" />
                    <path d="M6.5 36c2.6-7.2 8.3-11 13.5-11s10.9 3.8 13.5 11" fill="#5B6BD6" />
                </svg>
            </span>

            <div>
                <div class="pf-name">Amit Kumar</div>
                <div class="pf-role">B.Tech Student</div>

                <div class="pf-photo-btns">
                    <%-- Static buttons of the design. --%>
                    <button type="button" class="pf-btn-photo">Change Photo</button>
                    <button type="button" class="pf-remove">Remove</button>
                </div>
            </div>

        </div>
    </div>

    <%-- ======================= PERSONAL INFORMATION ==================== --%>
    <div class="pf-card">

        <h3 class="pf-info-title">Personal Information</h3>
        <hr class="pf-rule" />

        <div class="pf-field">
            <asp:Label ID="lblFullName" runat="server"
                AssociatedControlID="txtFullName"
                CssClass="form-label"
                Text="Full Name"></asp:Label>

            <asp:TextBox ID="txtFullName" runat="server"
                CssClass="form-control"
                Text="Amit Kumar"></asp:TextBox>
        </div>

        <div class="pf-field">
            <asp:Label ID="lblEmail" runat="server"
                AssociatedControlID="txtEmail"
                CssClass="form-label"
                Text="Email Address"></asp:Label>

            <asp:TextBox ID="txtEmail" runat="server"
                CssClass="form-control"
                Text="vtank755@rku.ac.in"></asp:TextBox>
        </div>

        <div class="pf-field">
            <asp:Label ID="lblPhone" runat="server"
                AssociatedControlID="txtPhone"
                CssClass="form-label"
                Text="Phone Number"></asp:Label>

            <asp:TextBox ID="txtPhone" runat="server"
                CssClass="form-control"
                MaxLength="10"
                Text="96248894623"></asp:TextBox>
        </div>

    </div>

</asp:Content>