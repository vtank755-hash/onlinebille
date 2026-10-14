<%@ Page Title="Edit User" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AdminEditUser.aspx.cs" Inherits="vivektank1.AdminEditUser" %>

<%-- Edit User page - opened from the edit (pencil) button of the admin
     user list pages (Dashboard User List, All / Active / Inactive / New Users).
     STATIC design page: the photo buttons, fields and "Update User" button
     are display only - nothing is saved.
     Database phase: fill the fields with ADO.NET and wire the update. --%>
<asp:Content ID="EditUserContent" ContentPlaceHolderID="AdminContent" runat="server">

    <%-- ======================= EDIT USER INFORMATION ======================= --%>
    <div class="admin-panel admin-profile-card">

        <div class="admin-profile-head">
            <h2 class="admin-profile-title">Edit User Information</h2>
            <p class="admin-profile-sub">Update account details and preferences for Rahul Sharma.</p>
        </div>

        <%-- ------------------------ PROFILE PHOTO ------------------------ --%>
        <div class="admin-profile-photo-row">

            <span class="admin-profile-photo-wrap">
                <span class="admin-profile-photo">RS</span>
                <span class="admin-profile-cam">
                    <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                        <path d="M9 2L7.17 4H4c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2h-3.17L15 2H9zm3 15c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5z" />
                    </svg>
                </span>
            </span>

            <span class="admin-profile-photo-meta">
                <span class="admin-profile-photo-title">Profile Photo</span>
                <span class="admin-profile-photo-hint">Allowed JPG or PNG, Max size of 800K</span>
                <span class="admin-profile-photo-actions">
                    <button type="button" class="admin-profile-upload">Upload New</button>
                    <button type="button" class="admin-profile-remove">Remove</button>
                </span>
            </span>

        </div>

        <%-- --------------------------- FIELDS ---------------------------- --%>
        <div class="admin-profile-grid">

            <div class="admin-profile-field">
                <label class="admin-profile-label" for="txtFullName">Full Name</label>
                <input class="admin-profile-input" id="txtFullName" type="text" readonly="readonly" value="Rahul Sharma" />
            </div>

            <div class="admin-profile-field">
                <label class="admin-profile-label" for="txtEmail">Email Address</label>
                <input class="admin-profile-input" id="txtEmail" type="text" readonly="readonly" value="rahul@email.com" />
            </div>

            <div class="admin-profile-field">
                <label class="admin-profile-label" for="txtMobile">Mobile Number</label>
                <input class="admin-profile-input" id="txtMobile" type="text" readonly="readonly" value="9876543210" />
            </div>

            <div class="admin-profile-field">
                <label class="admin-profile-label" for="txtStatus">Account Status</label>
                <input class="admin-profile-input admin-profile-status" id="txtStatus" type="text" readonly="readonly" value="Active" />
            </div>

            <div class="admin-profile-field admin-profile-field-full">
                <label class="admin-profile-label" for="txtAddress">Address</label>
                <textarea class="admin-profile-input" id="txtAddress" readonly="readonly" rows="3">123, MG Road, Mumbai</textarea>
            </div>

        </div>

        <%-- ---------------------- CANCEL / UPDATE ------------------------ --%>
        <div class="admin-profile-foot">
            <a class="admin-btn-back" id="lnkCancel" runat="server" href="AdminUserProfile.aspx">Cancel</a>
            <button type="button" class="admin-btn-update">Update User</button>
        </div>

    </div>

</asp:Content>
