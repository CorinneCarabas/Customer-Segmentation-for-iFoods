# Customer-Segmentation-for-iFoods
iFoods wants to maximize their sales by understanding their audience. Here's what I found.
![chart magnifying glass](https://github.com/user-attachments/assets/cd278605-5e41-44f6-9f49-d7409a14f82b)
[Dataset used](https://www.kaggle.com/code/hasibalmuzdadid/customer-personality-analysis-segmentation/notebook#notebook-container)

The main point of this entire project is to help iFoods understand their target audience and get an idea of the performance of their last 5 campaigns.

Check out the highlights of the below in my Executive Summary Presentation. [Canva link](https://www.canva.com/design/DAGMotb-poI/jQfTH3L8c5KlftPljVjK4A/edit?utm_content=DAGMotb-poI&utm_campaign=designshare&utm_medium=link2&utm_source=sharebutton)



SQL


I started off by cleaning the data using MySQL in the 8 steps detailed below.
[MySQL code file](https://github.com/CorinneCarabas/Customer-Segmentation-for-iFoods/blob/main/SQL%20Data%20Project_iFood%20Customer%20Data.sql)


-- 1. Standardize data

I edited one field from String to Date. I also decided to rename a lot of the columns to be a little more specific and descriptive.

-- 2. Remove duplicates

Checked, but fortunately, there were no duplicates.

-- 3. Null values or blank values

Checked for and removed any null and 0 values, or values that obviously don't bring any value.

-- 4. Remove any columns and rows

We could drop the CPGA and ARPU columns since they contain repeated numbers, but I decided to rename and keep for the viz purposes of this project.
I removed some rows where the Marital Statuses were unclear.

-- 5. Replacing values

I merged some records in the Education category, i.e. "2n Cycle" could be described as Postgraduate. In the Marital Status category, I merged "Alone" responses with "Single."

-- 6. Exploratory data analysis

I found and dropped some outliers, i.e. some 100-year-old (or older) customers. One record had an income of 666666, that seemed to far exceed the other records, so I removed those.

-- 7. Identifying top sellers

I got an idea of top-selling products (min, max, and averages). I also made a calculated column for Total Orders, to summarize the products for each customer.

-- 8. Beginning to identify CLV/loyalty

And finally, I wanted to get a good idea of how long the lifespans are for each user, with the intention of dropping this data into Excel next to get an idea of customer loyalty/CLV.


Excel
[Excel file](https://github.com/CorinneCarabas/Customer-Segmentation-for-iFoods/blob/main/SQL-Data-Project_iFood-Customer-Data.xlsx)


1. Generation
    
    Calculated current Generation with a VLOOKUP
    
2. Education
    
    Performed an IF function to summarize customers into College or No College. It was here I noticed I misspelled "School" in MySQL, so I did a quick Find and Replace and the IF statement started working as intended.
    
3. Income
    
    I noticed these income values were really all over the place. Not knowing for certain if these were monthly, or annual salaries, I couldn’t necessarily perform analysis on these. 
    I “asked” the owner of this data and they were able to clarify that any income amount over 10,000 was to be counted as annual. In this case, I wanted all salaries to be annual, so I recalculated this column to reflect that, labeled Annual Income.
    To further categorize these Incomes, I wanted to bracket them, so I found average/standard deviation, and created brackets 1-6 (lowest income to highest)
    
4. Parent
    
    I created an IF statement to say if either column had a value, that person is a parent.
    
5. Customer Since in Days
    
    I wanted to get an idea of average orders over the customer's lifetime, so I created a Current Date column with a formula of TODAY(), and created the Customer Since in Days, with TODAY-Customer_Since, so that if the file gets refreshed it’ll always be current (in this case, today should be 10/4/2014).
    I also moved the Total_Orders column next to Gold, so the Total is next to all the product counts.
    
6. Average Orders over Lifetime
    
    To get an understanding of how much volume over the time they’ve been a customer, I created a simple ratio, Total_Orders / Days
    
7. Last Purchase Overdue
    
    Knowing those who order frequently, but not knowing exactly how frequently, I wanted to prioritize those Highest and High-Priority customers with another average/standard deviation, just to get an idea of whether we were in danger of losing loyalty, or whether they could be recaptured in another campaign.
    I determined what date this data was most likely pulled by subtracting the Last Purchase number of days from the current date and determined that the “Current Date” should be 10/4/2014. 
    Then I marked the standard deviations from Highest to Lowest based on STD DEV. 
    Then I applied red color coding if they’re above-average based on priority brackets determined by STD DEV.
    
8. Changed “Response” to Converted
    
    I wanted to streamline the Conversion columns to match verbiage. There is a slight discrepancy where there is a “1” for Yes on one or more of the 5 campaigns, but the Converted column has a “0” for No. 
    I “asked” the marketing specialist and we came to the consensus that this was an error and the column should have a 1 for Yes, so I corrected that.
    For those that have a 1, but did not convert on Camps 1-5, "we" can conclude they eventually converted on a later camp, but we’re only focusing on these 5 campaigns for now.
    
9. Classifying Customer Base Tiers
    
    A formula for customers might vary by company, but I “asked” our Head of Marketing and we came to a consensus that the formula for Customer Classification should be scored this way: 
    
    4 points for above-average volume
    3 points for above-average orders over their lifetime
    2 points for above-average lifetime
    1 point for above-average income (wouldn’t normally be considered, but added this point because we want to target high-income customers)
    
    I then determined their total scores with IF statements and created a column for their corresponding tier with a VLOOKUP. Top Level Customers are Diamond, followed by Platinum, Gold, Silver, and Bronze. Customers with 0 points are labeled No Tier.
    

1. Pivot tables
   
    1. First I wanted to know which campaigns had the highest response rate 
        1. Divided Sum of Converted on Camps 1-5 by the total
        2. Added in Customer Tier to understand how often each Tier is responding.
        3. Compared Web Visits to Web Orders by Customer Tier
        4. Observations: 
            1. Response rates are pretty low. We could dive into the personas of each tier a little more, and attempt to uncover what each tier actually wants, to see if there are any opportunities for personalization and targeting, especially for Gold, Silver, and No Tier Customers.
            2. Campaign 2 overall had a very low response rate compared to the other 4. We should try to uncover what went wrong there. An early hypothesis could be technical issues, but we need to know if this campaign was an email, in-person, or mail/catalog campaign first. Or perhaps it was more targeted and not sent to a wide audience.
            3. In comparing Web Orders to Web Visits this Month, in some cases, it seems like there are more Orders than Visits, so that may mean that the Orders are over a longer period than one month, or there may be more visits unaccounted for, perhaps there are more users that weren’t tracked, or cookies limited ability to attribute back to a user. We’ll have to “ask” our marketing specialist to be sure.

    2. Next I wanted to see how many orders we could attribute to each Campaign. 
        1. Observations: 
            1. Campaign 2 had very low orders in comparison to the other 4. It might be worth looking into the differences between those that did convert on Campaign 2, vs the other 4. Another reason may be the length of time between Campaign 2 and 3. Maybe the 3rd campaign overshadowed the 2nd campaign. Or again, it could be a result of Campaign 2 having a smaller audience. 
    3. That being said I wanted to compare the Discounted orders to the campaign conversions
        1. Observations:
            1. Looks like the amount of discounted purchases jumped from 9.32% in campaign 2 to 16.33% in campaign 3. So perhaps that is evidence that the 3rd campaign did overshadow campaign 2 with a more compelling discount.

3. Recommendations to come out of the Excel analysis. 
    1. I created a list (”Overdue for Purchase” sheet) of the customers (and their Tier) who are overdue for purchase, including what they typically buy, how often they visited the website last month, and whether they could be persuaded by a discount. I also included where they usually purchase (in-store, web, or catalog). And it may also be important to consider if they’ve had a recent complaint, and address those customers separately, and more personally depending on Tier. 
    2. On that same sheet, there is a Pivot table that the "marketing specialist" and I can use to pull the list of User IDs for this retargeting campaign. I have it set up with the customers that are at a Medium priority or above, that are discount indifferent, with no complaints. I can now “work together with the marketing team" to decide on what retargeting campaigns to run. I can adjust this pivot table based on that discussion, and then simply double-click on the number of orders within the pivot table to get the list of User IDs.
      i. For example, the marketing team decides they want to run a campaign for Wine, with a featured wine that’s only available in stores, for a limited time. The head of marketing confirms that we should target these customers (medium priority and above, that are discount indifferent, that have no complaints, and usually shop in-store). The Grand Total for the number of Wine orders is 114,675. I double-click on that number and get a list of customers (Wine Campaign Users sheet) that we can send an email, and/or a postcard mailer to, a total of 168 customers. They won’t be able to resist! 😊



Tableau
[Tableau Public link](https://public.tableau.com/views/TableauDataAnalysisCustomerSegmentationProject-iFoods/DemographicsDashboard?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)
[Tableau file link](https://github.com/CorinneCarabas/Customer-Segmentation-for-iFoods/blob/main/Tableau%20Data%20Analysis%20Customer%20Segmentation%20Project%20-%20iFoods.twbx)


1. Demographic data
    1. First I wanted to create profiles of our most valuable customer personas. 
        1. I started by looking at how many users in each Tier there are. I immediately realized that there were only 44 customers that qualified as Gold Tier. That would explain why their metrics are low. So in this case, I will leave them there for now. As this database gets “updated” with more user data every month (hypothetically), then perhaps the Gold Tier will grow or shrink as time goes on. We should still focus on getting those Gold users into our retargeting campaign, and hopefully, they’ll grow into Platinum or Diamond. That is the ultimate goal, moving users into the next tier, and the next, and the next.
        2. So in the “Demographics Dashboard,” I pulled in the relevant demographic data, including generation, marital status, parental status, education status, and income bracket (if you hover over the individual income brackets you can see the median income for reference), the date we acquired them as a customer, the number of discounted purchases they made, and what product categories they buy. 
        3. Most of these are filterable, so if I only wanted to focus on Gen X, I could click on the Gen X pie slice and the rest of the dashboard would reflect only data about Gen X. I did this by creating a Worksheet for each demographic, dragged each into the Dashboard, made each floating, made each fit the window, made each “Use as Filter,” and arranged and color-coded them to a more appealing color scheme.
        4. So, looking at our most valuable customers, Diamonds, we can see that they are mostly Boomers and Gen X, they are mostly married, they are overwhelmingly college-educated, there are more non-parents than parents, and they’re mostly in that upper-middle band of income bracket (likely $67k-$81k). They’ve been customers for a while, about a year or longer if we were hypothetically in October of 2014. They are discount indifferent. And they primarily buy Wine and Meat. None of this is too surprising, considering the criteria we chose to qualify the different Tiers. But overall, this gives us a good snapshot of who our target audience is. 
        5. Contrastingly, if we want to explore our Bronze customers, there are more millennials, but mostly Gen X. They are mostly married, mostly college-educated, overwhelmingly parents, and mostly in the lower-middle income bracket (around $24k-$40k), and they’ve been customers a wide range of time, spanning the full range of this dataset. They buy Gold products (Gold is a “Premium” product) more often than Fish, Sweets, and Fruit. They also take discounts more often than all the other Tiers. This gives us a general idea of how we can target the Bronze customers, perhaps by increasing discount promotions on Gold products for these customers to encourage them to order more frequently or spend more in general.

2. KPI Dashboard
    1. Added Orders by User. If these accounts were owned by a Sales Rep, we could add that data in as well, so Sales could keep tabs on how their accounts are performing via the search bar, and proactively initiate conversations with those accounts if necessary.
    2. Similarly, Web Conversions could help a Sales Rep see if their account was visiting the website, but didn’t make an order. So they could personally reach out and try to make that conversion. Side note, a web conversion rate of 76.75% is pretty incredible, the average for a mobile app is somewhere in the neighborhood of like 20%. A website is more like 1%-4% (source). So iFoods is obviously doing something very right, or we’d want to check that we’re comparing apples to oranges as far as dates, or ask the marketing team for the integrity of this data.
    3. We could also automate this, if these weren't owned by a Rep, technology could handle it for "us."
    4. Added Popular Products to this dashboard as well, so if a sales rep wanted to see what products their accounts usually purchase, that info is also at their fingertips. 
    5. Added ARPU and CPGA. You can hover over the tooltip to see the details. 
    6. Added Complaint Rate (hover over tooltip to see details) and list of Complaints by User. Nothing’s more embarrassing than reaching out to a client to try to make a sale, and then finding out after the fact that they have an unresolved complaint. 😖
    7. The KPIs we could be tracking might also include Churn, CLV, Growth Rate, AOV (average order value), and NPS (net promoter score). The info I would need from the marketing team to complete these calculations would have to include 
        1. The specific order dates
        2. The order amounts in $
        3. We could also recommend deploying a short survey to our diamond customers, or our customers above Medium Priority (those that have an above-average order / lifetime) to get an idea of NPS and gather any qualitative data to improve our services, product offering, campaign subjects, etc.
    8. These KPIs are summarized on the side so anyone looking at this dashboard can be aligned with our business goals. Note that we don’t have orders by date, but I did “ask” for the QTD totals and put those figures on this dashboard. 

3. Campaign Performance
    1. Demographics at the top: customer tier, generation, marital status, income bracket, education status, and parental status. We could click on individual demographics to see what is resonating with a particular audience.
        1. For example, if we only want to see what campaigns parents converted on, we can click on the “parent” pie slice and see that most parents are in the Bronze and No Tier category. They’re mostly in that lower-middle-income bracket (~$41k). They also buy a fair amount of gold-label products. A lot of parents converted on campaigns 3 and 4. The discount rate is higher. 
    2. The campaign performance of each campaign: So since we don’t know the content of these campaigns before we “ask” the marketing team to send us the content, we can take a glance at the demographics between them and see if any patterns emerge. 
        1. So if I filter by clicking on the slice on the Campaign 1 bar labeled “Yes” we can see that 141 people converted. They were primarily our Diamond and Platinum customers, mostly boomers, mostly married, a majority in that high-income bracket (~$82k), all college-educated, and mostly parents. Some of these 141 people also converted on multiple campaigns, as evidenced by the fact that there are “Yes” in the other 4 campaigns as well.  The products these customers purchased were primarily wine and meat, and some fish. 
        2. Campaign 2 only had 30 people convert. But from the data, I’m noticing that the purchases of these customers are primarily wine, and they are customers that have lifespans longer than 1 year. So maybe this was an “exclusive wine” campaign for certain customers. 
        3. Campaign 3 was primarily conversions from our lower-tier customers, Bronze, and No Tier. An even mix of incomes, and mostly parents. None of the people who converted on Campaign 3 converted on Campaign 4. We can also see that this campaign had a large number of discount purchases associated with it. So that could mean that this set of customers are our go-to discount audience.
        4. Campaign 4 is pretty consistent with campaign 1’s demographics, but contains more of the upper-middle-income bracket, and has a much higher discount rate. So perhaps this campaign contained a coupon. 
        5. Campaign 5 is mostly all Diamond and Platinum customers, with more Millennials and 1 Gen Z in this campaign, still mostly partners or married individuals, in that higher income bracket, and overwhelmingly not parents. There were more meat orders than in some of the other campaigns. Very low discount rate. Perhaps this was another exclusive offer for our priority customers.
    3. Popular Products by Tier: just a note that since we don’t have actual order dates, we can see the products by user when we apply filters. 
    4. Discounted Purchases: take note of higher-than-average discount purchases amongst these campaigns.
    5. Date Acquired: If sales were looking at their customers, they could take note of the lifespan.
    6. Campaign conversions for each campaign by user: If sales were to search for their customers via the search bar (or if that was included in the data) they could see specifically what campaigns their customers resonated with.

4. My recommendations following this Tableau analysis
    1. Personalization & Automation
        1. We can automate if a customer has more web visits than orders, then they could be entered into an abandoned visit or “abandoned cart-like” campaign.
        2. We can automate when products are back in stock, or when a new product launches to alert customers that typically buy those items.
        3. We can advertise “hot” trending items
        4. We can automate when a customer goes overdue for purchase and send them a personalized campaign based on their unique set of demographics.
        5. We can also automate when a complaint pops up, we can prioritize it based on their customer tier and determine a proper course of action.
        6. We can determine their engagement score by how much they buy, and how often they convert and/or interact with campaigns.
        7.  A campaign that bundles “Something for you and something for them” - like a BOGO 50% off, and I would suggest targeting parents, who are not discount indifferent. When they make a purchase, get something else 50% off, up to 2 uses (to encourage buying a total of 4 items). For example, purchase 2 Wine products and get, 2 Gold-label products for 50% off. And the campaign might include imagery of a parent with their family, at a picnic, or something that shows multiple products, to encourage purchasing multiple items.
        8. We can personalize based on key demographics. i.e. we wouldn’t send the “something for you, something for them” with an image of a family campaign that I suggested to a single, non-parent individual. For a single, middle-to-high-income individual, We could simply swap the content and image to “Some for now, and some for later” with an image of a nice dinner setting showing multiple products.
     
    2. Deploy customer surveys to get an idea of NPS
    
    3. Loyalty programs 
            1. Maybe we could develop a loyalty program. We would likely first want to start by surveying customers what benefits they would look for in a loyalty program from iFoods. We would likely want to make sure that we’re keeping our discount-indifferent customers separate from those who partake in discounts to maximize profitability.
            2. Could help us boost Silver and Gold Tier customers up into Platinum and Diamond, by showing the benefits of exclusive products (like Campaign 2, if my theory about the content being exclusively for high-tier customers is correct).
    4. If we are assuming that sales reps own some of these higher-tier accounts, they could start taking more initiative now that they have easy access to information, and every time this workbook gets refreshed, they could take it upon themselves to proactively nurture their book of business by checking on what they buy, ensuring they have no complaints, checking to see if they have more website visits than orders, seeing what campaigns they converted on to get a better understanding of what resonates with them.
            a. For example, If I were a sales rep and I was interested in checking if any of my customers converted from Campaign 2, I could see that customer #5848 of “mine” has a volume over 2,000, is a platinum customer, they buy meat more than wine, converted from 3 out of 5 campaigns, so they’re obviously very interested in us, yet has only been a customer since the beginning of “this year” 2014. I would be reaching out to them regularly about when meat gets restocked, when new meat products are available, the latest trends in meat, if we have a new gift box that includes wine, meat, and other products, etc. I would also strive to make sure that I’m notified if that customer is overdue for a purchase, or shows up on the complaint list. I would prioritize this customer and try to get them into the Diamond Tier.
       
    5. I might suggest that we identify if selling fish, sweets, and fruit is still profitable. If these products aren’t serving us because there’s no demand, we may need to stop carrying them. Alternatively, we could dive into who actually buys these products. We would need more details, like the specific order details in order to do that though. 
        1. We could start offering a subscription service that bundles these products together, like a meal kit, or giftable kits, that include a mix of each product. 
        2. Or bundling proteins together (meat and fish) to encourage more fish sales. 
    
    6. Gold label: 
        1. Should these really be separated? At this point, we don’t know what products these are, we only know they’re a premium item. I think we should make this a separate column to denote Gold so that we know how much of a certain product was Gold or not. So for example “Gold Wine,” “Gold Meat,” etc.
        2. Why are Gold-label products more popular amongst the lower tier/lower income audience? Shouldn’t it be the other way around? We may need to dive into that further.

    7. My “year 2024 perspective” is telling me we should definitely have more web/app orders and less catalog orders. Maybe since it’s “2014” then this mix might make sense, but due to COVID, there should definitely be more online activity happening. We could begin maximizing this with targeted ads, abandoned cart campaigns, retargeting, etc.

    8. And finally, as mentioned above, we should round out this dataset with the rest of the data from “the marketing team” to finish building out these KPIs. We should certainly be measuring CLV (detailed above). It might also be nice to know revenue, in addition to volume. It may also be nice to know COGS, the cost of goods sold, to understand profit.
      
Having as much data as possible will allow us to understand even more about our audience, maximize CLV, and create great, long-lasting brands. :)
  


  Executive Summary Presentation
  [Canva link](https://www.canva.com/design/DAGMotb-poI/jQfTH3L8c5KlftPljVjK4A/edit?utm_content=DAGMotb-poI&utm_campaign=designshare&utm_medium=link2&utm_source=sharebutton)
  Check out the highlights in my Executive Summary.
       

If you have any questions about my process please reach out. Thank you for reading!
