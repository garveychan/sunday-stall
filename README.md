# T2A2 - Two-Sided Marketplace

### Coder Academy
### Sydney Fast-Track Bootcamp 2021

##### Garvey Chan

<hr>

# SundayStall

### Links (R9/R10)

![SundayStall Link](https://sundaystall.herokuapp.com)
![GitHub Link](https://github.com/garveycodes/ca-t2a2-marketplace)
![Trello Link](https://)

### The Market Problem (R7)

I believe that the long tail market for local value-added goods is underserved - e.g. hobbyist bakers, artisans, creators.

Not large or consistent enough to justify having the manage and curate their own presence across multiple platforms. - Shopify, Instagram, Facebook.

### Why is it a Problem that needs solving? (R8)

- Fragmented market with uncoordinated micro to medium-sized merchants.
- Discovery is difficult on mature platforms whose algorithms favour established business entities.

### Description (R11)

##### Purpose


##### Features


##### Sitemap

Home
-- Featured Stalls and Products | root, home#index

Buyer
-- View all Stalls | stalls, stalls#index
-- View Stall with all Products | stalls/id, stalls#show
-- View Product | stalls/id/products/id, products#show
-- Search Results | stalls/search, stalls#index -> with different @stalls instance

Seller
-- Create Stall | stalls/new, stalls#create
-- Create Product | stalls/id/products/new, products#create
-- Edit Stall | stalls/id/edit, stalls#edit
-- Edit Product | stalls/id/products/id/edit, products#edit
- Toggle Stall/Product status

User
-- Authentication
  -- Log In | users/sign_in, devise/sessions#new
  -- Sign Up | users/sign_up, devise/registrations#new
  -- Forgot Password? | users/password/new, devise/passwords#new
-- Favourites | favourites, favourites#index
  -- Logged out -> Sign Up page -> Add favourite
  -- Logged in -> not favourited? -> favourite
  -- Logged in -> favourited? -> unfavourite

--   Profile (Edit User)
  -- Edit Profile | users/edit, devise/registrations#edit

Admin
-- Dashboard | /admin, RailsAdmin::Engine

<!-- - Purchases | purchases, purchases#index -->
<!-- - Merchant Insights -->
<!-- - Messaging -->

##### Screenshots


##### Target Audience


##### Tech Stack


##### Walkthrough

<hr>

### The Development Process

##### Project Management (R20)

##### User Stories (R12)

As a user,
I want to be able to sign up with an account so that I can manage my presence on the website.

As a seller,
I want to set up my stall so that other users can see my brand and what I'm offering.
I want to add products to my stall with details so that buyers can see what's available for purchase.
I want to be able to edit and delete my stall so that I can manage my presence on the website.
I want to be able to edit and delete my products so I change what's available to my buyers.

As a buyer,
I want to view all stalls and products on the platform so that I can see the full range.
I want to search for stalls with keywords so that I can quickly find one that suits my needs.
I want to add my favourite stalls and products to a wish-list so that I can come back to them in the future.

As an administrator,
I want to have full access so that I can manage all listings on the platform.
I want to be able to view website statistics at a glance so I can make informed decisions about design.
I want to interrogate the database so that I can make adjustments if necessary.

##### Wireframes (R13)

##### Entity Relationship Diagram (R14)

##### High-Level Abstractions (R15)

##### Third Party Services (R16)

##### Rails Models (R17)
`belongs_to/has_many associations`

##### Database Relationships (R18)
`primary/foreign key associations`

##### Database Schema (R19)



### Application/Features

Two-sided Marketplace Web Application

- All Users
  - Listings Platform
  - Transaction Handling
  - Responsive Design
  - User Session Management
  - Payment Processing
  - Google Maps Autocomplete and Map View
- Sellers
  - Inventory Management
  - Content Management System
  - Customer Relationship Management
  - Seller Dashboard
- Buyers
  - Shopping Cart
  - Merchant Discovery (Search/Filter)
