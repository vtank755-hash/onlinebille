<%@ Page Title="Profile" Language="C#" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="vivektank1.Profile" %>

<%-- Profile - the profile of the signed-in user, read only:
     the personal information is shown as label + value rows (same card
     design of Edit Profile) and the "Edit Profile" button opens the
     EditProfile.aspx page. STATIC in this stage: the "Edit Profile"
     button only opens that page, nothing is saved here.
     Database phase: fill the values with
       SELECT FullName, Email, Phone FROM Users WHERE Email = @Email
     where @email is Session["UserEmail"]. --%>
<asp:Content ID="ProfileHeaderTitle" ContentPlaceHolderID="DashHeaderTitle" runat="server">Profile</asp:Content>

<asp:Content ID="ProfileBody" ContentPlaceHolderID="DashContent" runat="server">

    <%-- ==================== TITLE + EDIT PROFILE BUTTON ================== --%>
    <div class="pf-head">

        <div>
            <h2 class="pf-title">Profile</h2>
            <p class="pf-sub">Your personal information at a glance.</p>
        </div>

        <%-- Opens the Edit Profile page (design flow). --%>
        <a class="pf-save pf-edit-link" href="EditProfile.aspx"
            title="Open the Edit Profile page">Edit Profile</a>
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
                <asp:Label ID="lblName" runat="server" CssClass="pf-name" Text="Amit Kumar" />
                <asp:Label ID="lblRole" runat="server" CssClass="pf-role" Text="B.Tech Student" />
            </div>

        </div>
    </div>

    <%-- ======================= PERSONAL INFORMATION ==================== --%>
    <div class="pf-card">

        <h3 class="pf-info-title">Personal Information</h3>
        <hr class="pf-rule" />

        <div class="pf-info-row">
            <span class="pf-info-label">Full Name</span>
            <asp:Label ID="lblFullName" runat="server" CssClass="pf-info-value" Text="Amit Kumar" />
        </div>

        <div class="pf-info-row">
            <span class="pf-info-label">Email Address</span>
            <asp:Label ID="lblEmail" runat="server" CssClass="pf-info-value" Text="vtank755@rku.ac.in" />
        </div>

        <div class="pf-info-row">
            <span class="pf-info-label">Phone Number</span>
            <asp:Label ID="lblPhone" runat="server" CssClass="pf-info-value" Text="96248894623" />
        </div>

    </div>

</asp:Content>