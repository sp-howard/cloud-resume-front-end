api_url = "https://api.stevenhoward.net/viewcount";

fetch(api_url, { method: "GET" })
  .then((res) => res.json())
  .then((data) => {
    // Get all elements with the "view_count" class
    const viewcount_elements = document.getElementsByClassName("view_count");

    // Convert the HTMLCollection to an array using spread operator
    const elementsArray = [...viewcount_elements];
    
    // Iterate through each element and set the value
    elementsArray.forEach((element) => {
      element.innerHTML = `${data}`;
    });

    console.log(data);
  })
  .catch((err) => {
    console.log(err);
  });
