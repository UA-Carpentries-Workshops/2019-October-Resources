
gapminder <- read.csv("gapminder_clean.csv", stringsAsFactors = FALSE)

#How to install a new package
install.packages("dplyr")

#Don't forget to load packages so we can use their functionalities
library(dplyr)
library(ggplot2)

# The five main Dplyr commands
# select, filter, pipe, mutate, group_by, summarize


# select() chooses columns/variables. This will keep only the variables you select.
# select()
# equivalent to what command in shell? "cut" 
select(gapminder, lifeExp)
select(gapminder, lifeExp, year, country, continent)
select(gapminder, -continent)

# filter()  chooses rows/observations based on conditions
# filter()
filter(gapminder, continent == "Asia")
filter(gapminder, continent != "Oceania")
filter(gapminder, year > 2000)

#We can also use outside information to help subset data.
two.countries <- c('Kenya', 'Gibon')
filter(gapminder, country %in% two.countries)

#%in% will enable you to search all lines in the column country for all character strings in the two.countries file 
#and will return a TRUE if it finds an one of them.



# dplyr works by piping commands, like you learned to do in the command line. 
# What was the symbol we used in Unix? 
# Instead of the pipe `|`, we use `%>%`.
# mention cntl + shift + m
#How we would do it without dplyr
min(gapminder[,'lifeExp'])

gapminder %>% select(lifeExp) %>% min()


#But we can do more complex things with dplyr
gapminder %>% select(-pop, -gdpPercap) %>% filter(continent == "Asia",year == 2007) 


# mutate()
# If we want to make a new column, use `mutate`.  Don't forget we have to assign it if we want to keep the changes
gapminder <- gapminder %>% mutate(NewColumn = lifeExp - meanLifeExp)
gapminder


#Challenge 1
# Write a single command (which can span multiple lines and includes pipes) that will produce a 
# dataframe that has the African values for lifeExp, country and year, but not for other Continents. 
# How many rows does your dataframe have and why?
year_country_lifeExp_Africa <- gapminder %>%
  filter(continent == "Africa") %>%
  select(year, country, lifeExp)  
  

# Group_by() divides the dataframe into multiple data frames for each group value.
# Group_by() is much more exciting in conjunction with summarize(). This will allow 
# us to create new variable(s) by using functions that repeat for each of the continent-specific 
# data frames. That is to say, using the group_by() function, we split our original dataframe into 
# multiple pieces, then we can run functions (e.g. mean() or sd()) within summarize().
gapminder %>% 
  group_by(continent)
# gives us a data frame grouped by continent

# but that's not particularly useful. How about we get the mean life expectancy by continent? 
 gapminder %>% 
   group_by(continent) %>% 
   summarize(MeanLife = mean(lifeExp))
# summarize is much more powerful than group_by

# How about by continent and year? 
gapminder %>% 
  group_by(continent, year) %>% 
  summarize(MeanLife = mean(lifeExp))

# Let's add on the standard error as well and save the dataframe  
continent_year <- gapminder %>% 
  group_by(continent, year) %>%
  summarize(MeanLife = mean(lifeExp),
            SeLife = sd(lifeExp)/sqrt(n()))
#remember, the standard error is standard deviation divided by the square root of the number of observations. 


# let's plot this!
ggplot(data = continent_year, 
         mapping = aes(x = year, y = MeanLife, color=continent)) + 
   geom_line() + 
   geom_errorbar(mapping = aes(ymin = MeanLife - SeLife, 
                                  ymax = MeanLife + SeLife,
                                  width = 0.3))


# Challenge 2 
# Create a new dataframe that contains the minimum (MinExp) and maximum (MaxExp) life 
# expectancies for each country.

MinMaxExp <- gapminder %>% 
  group_by(country) %>% 
  summarize(MinExp = min(lifeExp),
            MaxExp = max(lifeExp))

# Challenge 3
# Calculate the average life expectancy per country. Which has the longest average life 
# expectancy and which has the shortest average life expectancy?

lifeExp_bycountry <- gapminder %>%
  group_by(country) %>%
  summarize(mean_lifeExp = mean(lifeExp))
lifeExp_bycountry %>%
  filter(mean_lifeExp == min(mean_lifeExp) | mean_lifeExp == max(mean_lifeExp))
# this last step could be done in a few different ways. What are ways that you came up with?  

# Challenge 4
# Challenge re-run
# Make a ggplot of the lifeExp vs year for the continents whose mean life expectancy is higher than average 
# from earlier
meanLifeExp <- mean(gapminder$lifeExp)

gapminder %>% 
  select(continent, lifeExp, year) %>%  
  group_by(continent, year) %>% 
  summarize(mean_exp = mean(lifeExp)) %>% 
  filter(mean_exp > meanLifeExp) %>%   
  ggplot(aes(x = year,y = mean_exp, color=continent)) + geom_line() + geom_point()



# Challenge 4
# Challenge re-run 
#  Make a ggplot scatterplot of the lifeExp vs GDPperCap for the countries whose average life expectancy is lower than average. Color the graph by continent.
gapminder %>% 
  select(country, lifeExp, gdpPercap,continent) %>% 
  group_by(country) %>% 
  summarize(mean_le = mean(lifeExp),
            mean_gdp = mean(gdpPercap),
            continent = first(continent)) %>% 
  filter(mean_le < meanLifeExp) %>% 
  ggplot(aes(x = mean_gdp, y = mean_le, color=continent)) + 
    geom_point()

  

