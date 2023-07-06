api_url = "https://qk9wmd00m9.execute-api.us-west-1.amazonaws.com/prod/viewcount";

fetch(api_url, { method: "GET" })
  .then((res) => res.json())
  .then((data) => {
    viewcount_element = document.getElementById("view_count");
    viewcount_element.innerHTML = `${data.body}`;
    console.log(data);
  })
  .catch((err) => {
    console.log(err);
  });
