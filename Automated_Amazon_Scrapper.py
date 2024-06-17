#!/usr/bin/env python
# coding: utf-8

# In[1]:


# import libraries

from bs4 import BeautifulSoup
import requests
import pandas as pd
import datetime
import time
import schedule
import os


# In[4]:


def amazon_best_seller():
    
    # Connect to Website and pull in data
    
    url = 'https://www.amazon.ca/kindle-dbs/browse/?_encoding=UTF8&pd_rd_w=23GPS&content-id=amzn1.sym.b1e38021-d5db-409b-b669-944e00b04a7f&pf_rd_p=b1e38021-d5db-409b-b669-944e00b04a7f&pf_rd_r=D2JYRS5FX02WRKY8EMKA&pd_rd_wg=dv3iX&pd_rd_r=a78104f2-1a24-4ac8-b6a0-84e77e6e893d&ref_=ts&widgetId=unified-ebooks-storefront-default_TopSellersStrategy&title=Best+Sellers&ref_=books_storefront_desktop_mfs_ts&sourceType=RECS&page=1&pd_rd_w=23GPS&content-id=amzn1.sym.b1e38021-d5db-409b-b669-944e00b04a7f&pf_rd_p=b1e38021-d5db-409b-b669-944e00b04a7f&pf_rd_r=D2JYRS5FX02WRKY8EMKA&pd_rd_wg=dv3iX&pd_rd_r=a78104f2-1a24-4ac8-b6a0-84e77e6e893d&metadata=%24deviceID%3A%24deviceFormFactor%3Alarge%24deviceAppType%3ADESKTOP%24deviceTypeID%3A%24deviceFamily%3A%24deviceSurfaceType%3Adesktop%24cardAppType%3ADESKTOP%24cardSurfaceType%3Adesktop%24cardMobileOS%3AUnknown%24sidekickLocale%3Aen-CA%24locale%3Aen-CA%24clientRequestId%3AD2JYRS5FX02WRKY8EMKA%24multiFormatWidgetSpClickUrlType%3Adefault'
    
    exchange_url = 'https://www.google.com/finance/quote/CAD-USD?sa=X&sqi=2&ved=2ahUKEwi1p8rTkuOGAxVXv4kEHefTChsQmY0JegQIFxAw'
    
    page = requests.get(url)
    
    soup = BeautifulSoup(page.text, 'html')
    
    ## pull book titles
    
    books = soup.find_all('span',{'class':"a-size-base a-color-base browse-text-line browse-larger-text-one-line"})
    
    book_titles = [title.text for title in books]
    
    ## Clean up data
    
    book_titles_clean = []

    for title in book_titles:
        title = title.replace('/n','').strip()
        book_titles_clean.append(title)
    
    ## pull book price
    
    book_cost = soup.find_all('span',{'class':"a-color-price a-text-bold"})
    
    book_price = [price.text for price in book_cost]
    
    ## clean up data
    
    book_price_clean = []

    for price in book_price:
        price = price.replace('CDN$','')
        book_price_clean.append(price)
    
    book_price_clean = pd.to_numeric(book_price_clean)
    
    # Create data Frame
    
    dict = {'book_titles':book_titles_clean,
            'price_in_CAD':book_price_clean}
    

    Amazon_best_seller = pd.DataFrame(dict)
    
    ## pull current exchange rate and find price in usd
    
    ex_page = requests.get(exchange_url)
    
    soup_ex = BeautifulSoup(ex_page.text,'html')

    ex_rate = soup_ex.find('div',{'class':"YMlKec fxKbKc"}).text
    
    ex_rate = pd.to_numeric(ex_rate)
    
    Amazon_best_seller['price_in_USD'] = Amazon_best_seller['price_in_CAD'] * ex_rate
    
    ## Create timestamp
    
    current_datetime = datetime.datetime.now()
    
    timestamp = pd.to_datetime(current_datetime)
    
    Amazon_best_seller['timestamp'] = timestamp
    
    # Create a CSV file to keep record
    
    if os.path.exists(r"D:\Case studies\Amazon_Scrapper\Amazon_best_seller.csv"):
        Amazon_best_seller.to_csv(r"D:\Case studies\Amazon_Scrapper\Amazon_best_seller.csv",mode = 'a',header = False, index = False)
    else:
        Amazon_best_seller.to_csv(r"D:\Case studies\Amazon_Scrapper\Amazon_best_seller.csv", index = False)


# Create a schedule to run the function daily        
        
schedule.every().day.do(amazon_best_seller)

while True:
    schedule.run_pending()
    time.sleep(1)


# In[5]:





# In[ ]:




