---
title: "R Exercises"
output:
  html_document:
    df_print: paged
date: "October 27, 2019"
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
require(tidyverse)
gapminder <- read.csv("https://raw.githubusercontent.com/swcarpentry/r-novice-gapminder/gh-pages/_episodes_rmd/data/gapminder_data.csv", stringsAsFactors = FALSE)
meanLifeExp <- mean(gapminder$lifeExp)


```

# Exercise 1
Q1. Which of the following will NOT return TRUE?

>A. FALSE == FALSE  
B. 10-5 == sqrt(25)  
C. TRUE > FALSE  
D. 'a' > 'b'

Q2. What is the output when we execute the following code?
x <- 3
y <- 2
y <- 17.4
x+y

>A. [1] 3  2  17.4  
B. [1] 22.4    
C. [1] 20.4   
D. [1] 5  

Q3. Use `str()` to look at the structure of the dataframe and `summary()` to get information about the variables.

>What are its columns?  
How many rows and columns are there?  
What is the earliest year in the `year` column?  
What is the average life expectancy?  
What is the largest population?  




# Exercise 2 : ggplot
### 3a. How would we look at life expectancy overtime with ggplot?

<details>
  <summary>Solution</summary>
  <p>

```{r}
ggplot(data = gapminder, mapping = aes(x = year, y = lifeExp)) +
  geom_point()
```

  </p>
</details>



### 3b. Try to add color.  
There is a color argument for the aes function  
You can can tell ggplot to color by continent  


<details>
  <summary>Solution</summary>
  <p>

```{r}
ggplot(data = gapminder, mapping = aes(x = year, y = lifeExp, color = continent)) +
  geom_point()
```

  </p>
</details>


### 3c. Switch the order of the geom_ functions. What happened?
<details>
  <summary>Solution</summary>
  <p>

```{r}
ggplot(data = gapminder, mapping = aes(x=year, y=lifeExp, by=country)) +
  geom_point() + geom_line(mapping = aes(color=continent))
```

  </p>
</details>




### 3d. Change the color and size of the points outside of aes.   
Note: ?geom_point
<details>
  <summary>Solution</summary>
  <p>

```{r}
ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) +
  geom_point(size=3, color="green") + scale_x_log10() +
  geom_smooth(method="lm", size=1.5)
```

  </p>
</details>




### 3e. Now change the shape of the points and color the points by the continent  
Note: You'll get multiple linear model fits  
Note: ?geom_point  

<details>
  <summary>Solution</summary>
  <p>

```{r}
ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp, color = continent)) +
  geom_point(size=3, shape=17) + scale_x_log10() +
  geom_smooth(method="lm", size=1.5)
``` 

  </p>
</details>
 



### 3f. Create a density plot of GDP per capita, filled by continent.  
Advanced: Transform the x axis to better visualise the data spread.  
Add a facet layer to panel the density plots by year.  

<details>
  <summary>Solution</summary>
  <p>

Answer:
```{r}
ggplot(data = gapminder, mapping = aes(x = gdpPercap, fill=continent)) +
  geom_density(alpha=0.6)# + facet_wrap( ~ year) + scale_x_log10()
```  
Advanced answer:
```{r}
ggplot(data = gapminder, mapping = aes(x = gdpPercap, fill=continent)) +
  geom_density(alpha=0.6) + facet_wrap( ~ year) + scale_x_log10()
```  

  </p>
</details>




# Exercise 3: loops

## Exercise 3a.  
If we have the following code:  
```{r eval=FALSE}
x <- 0
if(x > 0) {
  print('Positive number')
} else {
  print('Negative number')
}
```
What gets printed:
>A. "Positive number"  
B. "Negative number"  
C. Nothing gets printed  
D. Computer crashes and sets on fire  

## Exercise 3b.  
If we have the following code:  
```{r eval=FALSE}
x <- 'a'
if (x>0){
  print('Positive number')
} else if (x<0) { 
  print('Negative number')
} else if (x=='a'){
  print('aaaaaaaaa')
} else{
    print('Zero')
}
```
>A. "Positive number"  
B. "Negative number"  
C. "aaaaaaaaa"  
D. "Zero"  

## Exercise 3c.
### Write a script that loops through the gapminder data by continent and prints out whether the mean life expectancy is smaller or larger than 50 years.

<details>
  <summary>Solution</summary>
  <p>


```{r}
meanLifeExp <- mean(gapminder$lifeExp)

for(cont in unique(gapminder$continent)){
  if(mean(gapminder[gapminder$continent == cont, 'lifeExp']) > meanLifeExp){
    print(paste(cont, 'lifeExp is above average'))
  }
  else if (mean(gapminder[gapminder$continent == cont, 'lifeExp']) < meanLifeExp){
    print(paste(cont, 'lifeExp if below average'))
  }
  else{
    print(paste(cont, 'lifeExp is average'))
  }
}
```

  </p>
</details>


# Day 2 Challenge! 
#### Make a ggplot of the lifeExp vs year for the continents whose mean life expectancy is higher than average 

<details>
<summary>Solution</summary>
<p>
  
# Answer:
```{r}
conts = c()  
for( cont in gapminder$continent){  
  tmp <- mean(gapminder[gapminder$continent == cont, "lifeExp"])  
    
  if(tmp > meanLifeExp){    
    conts = c(conts, TRUE)  
  }    
  else{  
    conts = c(conts, FALSE)  
  }  
}  
continentsLongLived <- gapminder[conts,]  
ggplot(continentsLongLived, aes(x = year, y = lifeExp, color=continent,by=country)) + geom_point() + geom_line()  
```

 </p>
</details>

#### Alternative Challenge
#### Make a ggplot scatterplot of the lifeExp vs GDPperCap for the countries whose average life expectancy is lower than average. Color the graph by continent. 
<details>
  <summary>Solution</summary>
  <p>
    
Answer:
```{r}
countries <- c()
for( count in gapminder$country){
  tmp <- mean(gapminder[gapminder$country == count, "lifeExp"])
  
  if(tmp < meanLifeExp){
    #print(paste("Average Life Expectancy in", count, "is more than", meanLifeExp, "plotting life expectancy graph..."))
    countries = c(countries, TRUE)
  }
  else{
    countries= c(countries, FALSE)
  }
}
```
shortLivedConutries <- gapminder[countries,]
ggplot(shortLivedConutries, aes(x = gdpPercap, y = lifeExp, color=continent)) + geom_point()
 </p>
</details>


# Exercise 4: Dplyr
#### 4a. Write a single command (which can span multiple lines and includes pipes) that will produce a dataframe that has the African values for lifeExp, country and year, but not for other Continents. How many rows does your dataframe have and why?

<details>
  <summary>Solution</summary>
  <p>
    
```{r}
year_country_lifeExp_Africa <- gapminder %>%
  filter(continent == "Africa") %>%
  select(year, country, lifeExp) 
head(year_country_lifeExp_Africa)
```

  </p>
</details>


#### 4b. Create a new dataframe that contains the minimum (MinExp) and maximum (MaxExp) life expectancies for each country.
<details>
  <summary>Solution</summary>
  <p>

```{r}
MinMaxExp <- gapminder %>% 
  group_by(country) %>% 
  summarize(MinExp = min(lifeExp),
            MaxExp = max(lifeExp))

head(MinMaxExp)
```

  </p>
</details>


#### 4c. Calculate the average life expectancy per country. Which has the longest average life expectancy and which has the shortest average life expectancy?
<details>
  <summary>Solution</summary>
  <p>

```{r}
gapminder %>%
  group_by(country) %>%
  summarize(mean_lifeExp = mean(lifeExp)) %>%
  filter(mean_lifeExp == min(mean_lifeExp) | mean_lifeExp == max(mean_lifeExp))
```

  </p>
</details>

### 4d. Challenge re-run: Make a ggplot of the lifeExp vs year for the continents whose mean life expectancy is higher than average 

<details>
  <summary>Solution</summary>
  <p>
    
```{r}
gapminder %>% 
  select(continent, lifeExp, year) %>%  
  group_by(continent, year) %>% 
  summarize(mean_exp = mean(lifeExp)) %>% 
  filter(mean_exp > meanLifeExp) %>%   
  ggplot(aes(x = year,y = mean_exp, color=continent)) + geom_line() + geom_point()
```
 </p>
</details>

#### 4e. Alt challenge re-run: Make a ggplot scatterplot of the lifeExp vs GDPperCap for the countries whose average life expectancy is lower than average. Color the graph by continent.
<details>
  <summary>Solution</summary>
  <p>
    
```{r}  
    
gapminder %>% 
  select(country, lifeExp, gdpPercap,continent) %>% 
  group_by(country) %>% 
  summarize(mean_le = mean(lifeExp),
            mean_gdp = mean(gdpPercap),
            continent = first(continent)) %>% 
  filter(mean_le < meanLifeExp) %>% 
  ggplot(aes(x = mean_gdp, y = mean_le, color=continent)) + 
    geom_point()
```    
 </p>
</details>

