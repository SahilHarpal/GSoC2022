# GSoC2022

Things I did/learn as a part of Google Summer of Code in 2022 at PostgreSQL.

## Development environment setup guide

The current repository doesn't contain any README and installation guide. So I have added installation steps and other required files.

- Added `README.md` for project description and contribution guidelines

- Added `requirements.txt`, which contains the project's dependencies

- Added installation guide [dev_install.md](dev_install.md)

- Created separate [table.sql](table.sql) file for database initialization

- NOTE:- You need to download mbox for `pgsql-hackers` list and include it in the `loader` directory for sample data ([Download link](https://www.postgresql.org/list/pgsql-hackers/mbox/pgsql-hackers.202207))



## Bootstrap-table dependency

In new design I have used [Bootstrap Table](https://bootstrap-table.com/) which is an extended version of `Table` component of Bootstrap

- Added `bootstrap-table.min.css` and `bootstrap-table.min.js` in the **/media/** directory
- Imported these files in the `base.html`



## Base layout

### 1. Removed inconsistency of CSS
  If you install and run the pgarchives code available in the [pgarchives repository](https://github.com/postgres/pgarchives) and compare it with the [https://www.postgresql.org/list/](https://www.postgresql.org/list/). You will notice the difference.

  The font family, color, weight and table's background color is different

  ![image](https://user-images.githubusercontent.com/56965873/188971812-cd29124f-d931-4de1-b803-2e00e8ba2a9e.png)
  ![image](https://user-images.githubusercontent.com/56965873/188971867-9e5b43ba-1ecc-4a38-b055-3790681a7b42.png)


### 2. Added link hover effect
  The hover effect is not present for any link. We must have this as it clearly shows what the user has selected or the cursor's position.

---

+ Patch for above 2 updates: [patches/0001-Removed-inconsistency-of-CSS-added-link-hover-effect.patch](patches/0001-Removed-inconsistency-of-CSS-added-link-hover-effect.patch) 

+ File affected: `django/media/css/main.css`

---

### 3. Redesigned the side navbar
- Changed background color to distinguish the side navbar from the main page content.
- Added hover effect for links and changed the display of <a> tag to block, which makes links clickable for the entire outer <li> tag. It gives the user a feel of the button, so they don’t need to move the cursor over text carefully.
- Also, the current quick links section/side nav disappears on scrolling the page. To access that side nav user again needs to scroll up. I think it won’t give users an experience of accessing things quickly as they need to scroll up and down every time. To improve this, I fixed the side-nav position to the left. So the side nav will remain at the same place after scrolling.
- Added appropriate icons for each quick link.

![image](https://user-images.githubusercontent.com/56965873/189035781-65df82cd-f13c-4a44-9137-ce02622de4ee.png)

---

+ Patch: [patches/0001-Redesigned-the-side-navbar.patch](patches/0001-Redesigned-the-side-navbar.patch) 

+ Files affected: `django/archives/mailarchives/templates/page.html` | `django/media/css/main.css`

---


### 4. Used Accordion for general info
- Used accordion for initial points (listed below)
  -   What are the PostgreSQL Mailing Lists?
  -   Tips For Using the PostgreSQL Mailing Lists
  -   How to Subscribe or Unsubscribe
- These points are optional, like FAQs. The interested person can read the content by clicking on the corresponding point. So by using accordion we can save page size and avoid unnecessary scrolling on this page.
- Designed this using onclick event and animation to enrich the user experience.

![image](https://user-images.githubusercontent.com/56965873/189102371-e899ad98-9c59-4380-8948-f44c60e80b41.png)

### 5. Redesigned mailing list table. Changed layout and added search & pagination functionality
- Used [bootstrap-table](https://bootstrap-table.com/docs/getting-started/introduction/) to redesign the tables.
- Instead of using CDN I downloaded css & js files and added them to the media directory.
- Used different background colors for the table header and table entries.
- Added links class/effect to list names so that things will be consistent throughout the page.
- Added horizontal line to separate two list groups.
- Used pagination and added an option to configure max entries to be displayed.
- Added a search box for each table to quickly search for a specific list of that group.
  
![image](https://user-images.githubusercontent.com/56965873/189103475-851bf57e-2afe-4f7e-a77f-2206eae6bea7.png)

---

+ Patch for above 2 updates: [patches/0001-Used-Accordion-for-general-info-redesigned-mailing-l.patch](patches/0001-Used-Accordion-for-general-info-redesigned-mailing-l.patch) 

+ Files affected: `django/archives/mailarchives/templates/index.html` | `django/media/css/main.css`

---


## Redesigned month list page
- Used a different color for the header of the table
  - In the current design, years are not clearly visible. It has been dissolved in all reddish text. 
  - Color used - Official PostgreSQL blue color [#336791]
- Used accordion for each year which contains a month list. 
  - It will be helpful in the the future as in the current design, we have a separate table for each year containing a month list and action to view the archives and download mbox. This representation will affect user experience in the coming years as there will be too many tables if we think about the next couple of years. Much scrolling will be required to look at archives of a particular year and month. Use of accordion will definitely prevent long scrolling
- Added search box
  - We don’t have any option to go to a specific year quickly 
  - This search box will allow users to enter a year and it will display only that particular year's accordion
  - Included in the `django/media/js/main.js`
- Replaced text with icons
  - Currently, we are using view archives and download mbox text repeatedly, which is not giving a good feel
  - To avoid this repetition of text, I used appropriate icons
- Added hover effect to elements (month name, archives & download icon)
  
![image](https://user-images.githubusercontent.com/56965873/189161944-a0212779-a678-45cb-89d1-4fec6bd26ec6.png)

---

+ Patch: [patches/0001-Updated-month-list-page.patch](patches/0001-Updated-month-list-page.patch) 

+ Files affected: `django/archives/mailarchives/templates/monthlist.html` | `django/media/css/main.css` | `django/media/js/main.js`

---
  
## Redesigned date list page
- Used a different color for the header of the table to make it distinguishable from table entries
- Added option to configure max entries to be displayed to avoid long scrolling
- Added client-side search box to search particular threads quickly
- Added hover effect to each data row
- Added bit spacing around each data entry to increase readability
  
![image](https://user-images.githubusercontent.com/56965873/189487348-843db36f-63a0-4eba-8c0d-0d661bbc18ba.png)

---

+ Patch: [patches/0001-Redesigned-date-list-page.patch](patches/0001-Redesigned-date-list-page.patch) 

+ Files affected: `django/archives/mailarchives/templates/datelist.html` | `django/archives/mailarchives/templates/datelist_topandbottom.html` | `django/media/css/main.css`

---
  
## Redesigned thread header 

- The header part of the thread looks very congested and hard to read
  - So added more spacing between 2 lines. Also, the used bullets for each info
- For views, used buttons instead of simple text
- Added functionality to copy message id
- Created filter to map username to email to avoid displaying a long list of a username followed by emails in cc/to list
- Handled horizontal overflow in case of smaller width devices
  
![image](https://user-images.githubusercontent.com/56965873/189491250-07abd592-c0fc-4602-a9f1-de9d4fa50bb3.png)

---

+ Patch: [patches/0001-Redesigned-thread-header.patch](patches/0001-Redesigned-thread-header.patch) 

+ Files affected: `django/archives/mailarchives/templates/_message.html` | `django/archives/mailarchives/templatetags/pgfilters.py` | `django/media/css/main.css` | `django/media/js/main.js`

---

## Updated "Your account" navbar option
- In the navbar, instead of Your account, displaying the user name along with the profile icon would be more appealing
- Displaying your account to unauthenticated/new users gives intuition that they have an account and are logged in, which is not true 
- The new design displays dynamic text, either login or username, along with a profile icon.
  - If a user is logged in, show the username
  - Else display text login 

![image](https://user-images.githubusercontent.com/56965873/189543355-5642559f-dc57-48a1-9663-69574c90e605.png)
  
---

+ Patch: [patches/0001-Updated-your-account-nav-option.patch](patches/0001-Updated-your-account-nav-option.patch) 

+ File affected: `django/archives/mailarchives/templates/base.html`

---
