<%@ Page Title="All Users" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AdminAllUsers.aspx.cs" Inherits="vivektank1.AdminAllUsers" %>

<%-- All Users page - opened from the "Total Users" card of the Admin Dashboard.
     Shows the complete user list (ACTIVE + INACTIVE) in one table.
     Design page: the search box, filter and add buttons are display only.
     Database phase: fill the table with ADO.NET from SQL Server. --%>
<asp:Content ID="AllUsersContent" ContentPlaceHolderID="AdminContent" runat="server">

    <%-- ============================ ALL USERS LIST ========================== --%>
    <div class="admin-panel">

        <div class="admin-panel-head">
            <h2 class="admin-panel-title">All Users List</h2>
            <div class="admin-panel-actions">

                <div class="admin-search">
                    <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" width="16" height="16"
                         fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                         stroke-linejoin="round" aria-hidden="true">
                        <circle cx="11" cy="11" r="7" />
                        <path d="M20 20l-4-4" />
                    </svg>
                    <input type="text" class="admin-search-input" placeholder="Search users..." />
                </div>

                <button type="button" class="admin-btn-outline">
                    <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                        <path d="M3 5h18l-7 8v5.5l-4 2V13L3 5z" />
                    </svg>
                    Registration Date
                </button>

                <button type="button" class="admin-btn-primary">
                    <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" aria-hidden="true">
                        <path d="M12 5v14M5 12h14" />
                    </svg>
                    Add User
                </button>

            </div>
        </div>

        <div class="admin-table-wrap">
            <table class="admin-table admin-user-table">
                <thead>
                    <tr>
                        <th>User ID</th>
                        <th>Full Name</th>
                        <th>Email Address</th>
                        <th>Mobile</th>
                        <th>Reg. Date</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><a class="admin-user-id" href="#">USR-001</a></td>
                        <td>
                            <span class="admin-user-cell">
                                <span class="admin-avatar admin-avatar-blue">RS</span>
                                <span class="admin-user-name">Rahul Sharma</span>
                            </span>
                        </td>
                        <td>rahul@email.com</td>
                        <td>9876543210</td>
                        <td class="admin-reg-date">24 Oct 2023</td>
                        <td><span class="admin-badge-active">Active</span></td>
                        <td>
                            <span class="admin-actions">
                                <a class="admin-icon-btn" href="AdminUserProfile.aspx" title="View">
                                    <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                                        <path d="M12 5C6.5 5 2.7 9.4 2 12c.7 2.6 4.5 7 10 7s9.3-4.4 10-7c-.7-2.6-4.5-7-10-7zm0 11.5A4.5 4.5 0 1 1 12 7.5a4.5 4.5 0 0 1 0 9zm0-2a2.5 2.5 0 1 0 0-5 2.5 2.5 0 0 0 0 5z" />
                                    </svg>
                                </a>
                                <a class="admin-icon-btn" href="AdminEditUser.aspx" title="Edit">
                                    <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                                        <path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04a1 1 0 0 0 0-1.41l-2.34-2.34a1 1 0 0 0-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z" />
                                    </svg>
                                </a>
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <td><a class="admin-user-id" href="#">USR-002</a></td>
                        <td>
                            <span class="admin-user-cell">
                                <span class="admin-avatar admin-avatar-green">PP</span>
                                <span class="admin-user-name">Priya Patel</span>
                            </span>
                        </td>
                        <td>priya@email.com</td>
                        <td>9876543211</td>
                        <td class="admin-reg-date">12 Nov 2023</td>
                        <td><span class="admin-badge-active">Active</span></td>
                        <td>
                            <span class="admin-actions">
                                <a class="admin-icon-btn" href="AdminUserProfile.aspx" title="View">
                                    <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                                        <path d="M12 5C6.5 5 2.7 9.4 2 12c.7 2.6 4.5 7 10 7s9.3-4.4 10-7c-.7-2.6-4.5-7-10-7zm0 11.5A4.5 4.5 0 1 1 12 7.5a4.5 4.5 0 0 1 0 9zm0-2a2.5 2.5 0 1 0 0-5 2.5 2.5 0 0 0 0 5z" />
                                    </svg>
                                </a>
                                <a class="admin-icon-btn" href="AdminEditUser.aspx" title="Edit">
                                    <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                                        <path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04a1 1 0 0 0 0-1.41l-2.34-2.34a1 1 0 0 0-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z" />
                                    </svg>
                                </a>
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <td><a class="admin-user-id" href="#">USR-003</a></td>
                        <td>
                            <span class="admin-user-cell">
                                <span class="admin-avatar admin-avatar-purple">VM</span>
                                <span class="admin-user-name">Vikram Malhotra</span>
                            </span>
                        </td>
                        <td>vikram@email.com</td>
                        <td>9876543212</td>
                        <td class="admin-reg-date">10 Jan 2024</td>
                        <td><span class="admin-badge-inactive">Inactive</span></td>
                        <td>
                            <span class="admin-actions">
                                <a class="admin-icon-btn" href="AdminUserProfile.aspx" title="View">
                                    <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                                        <path d="M12 5C6.5 5 2.7 9.4 2 12c.7 2.6 4.5 7 10 7s9.3-4.4 10-7c-.7-2.6-4.5-7-10-7zm0 11.5A4.5 4.5 0 1 1 12 7.5a4.5 4.5 0 0 1 0 9zm0-2a2.5 2.5 0 1 0 0-5 2.5 2.5 0 0 0 0 5z" />
                                    </svg>
                                </a>
                                <a class="admin-icon-btn" href="AdminEditUser.aspx" title="Edit">
                                    <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                                        <path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04a1 1 0 0 0 0-1.41l-2.34-2.34a1 1 0 0 0-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z" />
                                    </svg>
                                </a>
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <td><a class="admin-user-id" href="#">USR-004</a></td>
                        <td>
                            <span class="admin-user-cell">
                                <span class="admin-avatar admin-avatar-purple">AV</span>
                                <span class="admin-user-name">Amit Verma</span>
                            </span>
                        </td>
                        <td>amit@email.com</td>
                        <td>9876543214</td>
                        <td class="admin-reg-date">05 Dec 2023</td>
                        <td><span class="admin-badge-active">Active</span></td>
                        <td>
                            <span class="admin-actions">
                                <a class="admin-icon-btn" href="AdminUserProfile.aspx" title="View">
                                    <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                                        <path d="M12 5C6.5 5 2.7 9.4 2 12c.7 2.6 4.5 7 10 7s9.3-4.4 10-7c-.7-2.6-4.5-7-10-7zm0 11.5A4.5 4.5 0 1 1 12 7.5a4.5 4.5 0 0 1 0 9zm0-2a2.5 2.5 0 1 0 0-5 2.5 2.5 0 0 0 0 5z" />
                                    </svg>
                                </a>
                                <a class="admin-icon-btn" href="AdminEditUser.aspx" title="Edit">
                                    <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                                        <path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04a1 1 0 0 0 0-1.41l-2.34-2.34a1 1 0 0 0-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z" />
                                    </svg>
                                </a>
                            </span>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <div class="admin-table-foot">
            <span class="admin-table-info">Showing 1 to 4 of 150 entries</span>
            <div class="admin-pagination">
                <button type="button" class="admin-page-btn">Previous</button>
                <button type="button" class="admin-page-btn is-current">1</button>
                <button type="button" class="admin-page-btn">2</button>
                <button type="button" class="admin-page-btn">3</button>
                <button type="button" class="admin-page-btn">Next</button>
            </div>
        </div>

    </div>

    <%-- ============================= BACK ================================ --%>
    <div class="admin-back-row">
        <a class="admin-btn-back" href="AdminDashboard.aspx">back</a>
    </div>

</asp:Content>
