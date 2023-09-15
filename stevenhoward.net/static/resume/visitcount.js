// Define the API URL to fetch data from
api_url = "https://api.stevenhoward.net/viewcount";

// Perform a GET request to the API URL
fetch(api_url, { method: "GET" })
  .then((res) => res.json()) // Parse the response as JSON
  .then((data) => {
    // Get all elements with the "view_count" class
    viewcount_elements = document.getElementsByClassName("view_count");

    // Convert the HTMLCollection to an array using spread operator
    elementsArray = [...viewcount_elements];

    // Iterate through each element and set the value
    elementsArray.forEach((element) => {
      element.innerHTML = `${data}`;
    });

    // Log the fetched data to the console
    console.log(data);
  })
  .catch((err) => {
    // Handle any errors that occur during the fetch request
    console.log(err);
  });