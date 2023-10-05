USE `recipes`;
SELECT * FROM categories, ingredients, rec_ingredients, recipe_main;

/*Once you run the sql code you’ll notice that each table has data populated for two recipes, Chicken Marsala and Absolute Brownies.
Use the INSERT INTO statement to insert new information about two (2) completely new recipes of your choosing into the database.*/

/* Recipe 1* Pizza*/
SELECT * FROM categories;
INSERT INTO categories(category_id, category_name)
VALUES (3, "ICE CREAM");

SELECT * FROM ingredients;
SELECT max(ingredient_id) FROM ingredients;
SELECT min(ingredient_id) FROM ingredients;

INSERT INTO ingredients(ingredient_id, ingred_name) 
VALUE (20, "Mozzerlla Cheese");

select* from ingredients where ingredient_id = 20;
SELECT * FROM rec_ingredients;

INSERT INTO rec_ingredients(rec_ingredient_id, recipe_id, amount, ingredient_id)
VALUES (17, 3, 5.00,20);

SELECT * FROM recipe_main;
INSERT INTO recipe_main(recipe_id, rec_title, category_id, recipe_desc, prep_time, cook_time, servings, difficulty, directions)
VALUES (3, "PIZZA", 3, "Jalepeno, Olive, Extra Cheese", 5, 15, 5, 3, "Wheat Base Put in pre-heat oven for 20 minutes");

/* Recipe 2 : Burger*/
SELECT * FROM categories;
INSERT INTO categories(category_id, category_name)
VALUES (4, "Gulab");

SELECT * FROM ingredients;
SELECT max(ingredient_id) FROM ingredients;
SELECT min(ingredient_id) FROM ingredients;

INSERT INTO ingredients(ingredient_id, ingred_name)
VALUE (21, "Wheat Floor");


SELECT * FROM rec_ingredients;
INSERT INTO rec_ingredients(rec_ingredient_id, recipe_id, amount, ingredient_id)
VALUES (18, 4, 20.00,21);

SELECT * FROM recipe_main;
INSERT INTO recipe_main(recipe_id, rec_title, category_id, recipe_desc, prep_time, cook_time, servings, difficulty, directions)
VALUES (4, "Burger", 4, "Onion, Tomatoes, Cheese Slice", 6, 16, 20, 15, "Bun Bread with Grains Put for 1 minutes in microwave");

SELECT * FROM categories, ingredients, rec_ingredients, recipe_main;

/* Part 2 Question 2: Write only one SQL query that returns all information on only 
the two new recipes you inserted from all the tables you created in step 1 above.*/

SELECT 
    *
FROM
    recipe_main r
        LEFT OUTER JOIN
    categories c ON r.category_id = c.category_id
        LEFT OUTER JOIN
    rec_ingredients ri ON r.recipe_id = ri.recipe_id
        LEFT OUTER JOIN
    ingredients i ON ri.ingredient_id = i.ingredient_id
WHERE
    r.recipe_id > 2;

/*Question 3: Write a SELECT query that identifies the recipe name, category name, and ingredient name, 
and ingredient amount. No other variables should be included.
Your output should be sorted first by descending category name, then by ascending recipe name,
 followed by descending ingredient name.
Recall that string variables are sorted alphabetically (ascending only) when you check your query results.*/

SELECT 
    r.rec_title, c.category_name, i.ingred_name, ri.amount
FROM
    recipe_main r
        LEFT OUTER JOIN
    categories c ON r.category_id = c.category_id
        LEFT OUTER JOIN
    rec_ingredients ri ON r.recipe_id = ri.recipe_id
        LEFT OUTER JOIN
    ingredients i ON ri.ingredient_id = i.ingredient_id
ORDER BY c.category_name DESC , r.rec_title ASC, i.ingred_name DESC;


/****************************Finish Assignment Part 2******************************************/

