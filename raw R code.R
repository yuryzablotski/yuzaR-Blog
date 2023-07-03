# Load the dplyr package
library(dplyr)

# Create the Customer Information table
customer_info <- data.frame(
  CustomerID = c("001", "002", "003"),
  Name       = c("John", "Sarah", "Michael"),
  Age        = c(25, 30, 28),
  Email = c("john@example.com", 
            "sarah@example.com", 
            "michael@example.com") )

# Create the Purchase History table
purchase_history <- data.frame(
  CustomerID   = c("001", "002", "004"),
  PurchaseDate = as.Date(
    c("2022-07-15", "2022-06-10", 
      "2022-08-20")),
  Product      = c("Laptop", "Phone", 
                   "Headphones") )

# Perform the inner join
inner_join(customer_info, purchase_history, 
           by = "CustomerID")

x <- tibble(
  A = c("1", NA, "2"), 
  B = c("a", "b", "a"))

y <- tibble(
  A = c("1", "2"), 
  B = c("a", "b"))

z <- tibble(
  A = c("3", "2", "1"), 
  C = c("a", "b", "c"), 
  D = c("here", "you", NA))

library(gridExtra)
grid.arrange(
  tableGrob(x),
  tableGrob(y),
  tableGrob(inner_join(x, y)),
  ncol = 3)

# Perform the left join
left_join(customer_info, purchase_history, 
          by = "CustomerID")

# Create the first table
t1 <- data.frame(
  ID = c(1, 2, 3),
  Name = c("John", "Sarah", "Michael")
)

# Create the second table
t2 <- data.frame(
  Identifier = c(1, 2, 3),
  Value = c(10, 20, 30)
)

left_join(t1, t2)

left_join(t1, t2, by = c("ID" = "Identifier"))

right_join(customer_info, purchase_history)
left_join(purchase_history, customer_info)

inner_join(customer_info, purchase_history)
left_join(customer_info, purchase_history)
right_join(customer_info, purchase_history)
full_join(customer_info, purchase_history)

x <- tibble(
  A = c("1", NA, "2"), 
  B = c("a", "b", "a"))

z <- tibble(
  A = c("3", "2", "1"), 
  C = c("a", "b", "c"), 
  D = c("here", "you", NA))

library(gridExtra)
grid.arrange(
  tableGrob(x),
  tableGrob(z),
  tableGrob(full_join(x, z)),
  ncol = 3)

inner_join(customer_info, purchase_history)
semi_join(customer_info, purchase_history)

anti_join(customer_info, purchase_history)
anti_join(customer_info, customer_info)
