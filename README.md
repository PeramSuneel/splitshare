# splitshare
Trip bill splitter in ₹. Add friends, log expenses, see who owes whom, and share the settlement on WhatsApp or email. Guest mode, saved trips and a mobile-friendly UI.
Split trip expenses with friends,see exactly who owes whom,and settle up in rupees.Works in the browser on desktop and mobile,with no install and no ads.
Status: working prototype. Accounts and trips are currently saved in the browser only (demo backend). A Supabase backend schema is included for the production version.
 Features
Guest modeuse the full calculator without signing up.Data is temporary and cleared when the tab closes.
Accountsregister,login,forgot password,profile and edit profile.Passwords are hashed,never stored as plain text.
Dashboardwelcome screen with new trip,my trips,pending settlements,total expenses and recent trips.
Tripsadd participantsyou are added automatically,log expenses,choose who paid and who shared.
Exact mathsamounts are handled in whole paiseno floating-point errors,and shares always add up to the total.
Smart settlementshows the few payments needed to clear everyones balance,such asRahul pays Suneel₹1,150.
Settlement trackingmark payments as settled,undo them,and see pending and completed lists.
Share summarysend a clean summary by WhatsApp,email or copy.Nothing is sent without your confirmation.
Responsive blue UIbottom navigation on phones,top menu on desktop.
 Getting started
No build step is needed.
Downloadsplitshare.html.
Open it in any modern browser.
ChooseContinue as Guest,or register to save your trips.
 Project structure
File
Purpose
splitshare.html
The whole appUI,calculation coreCoreand data layerLocalDB
supabase-schema.sql
Database tables and row-level security for the live backend
The calculation logicCorehas no screen or storage code,so the website and the Android app can share it unchanged.
 Roadmap
Connect Supabasesecure login,per-user data,password reset by email
Android app using Capacitor
Unequal splitspercentage and exact amounts
Email verification and password change in Profile
 Privacy
Guest data is never saved to an account or database.
Only the details needed for the app are collectedname,mobile and email.
When the live backend is connected,each user can only access their own tripsrow-level security,and no secret keys are kept in the app.
