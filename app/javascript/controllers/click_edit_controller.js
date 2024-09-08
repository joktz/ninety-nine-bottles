import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="click-edit"
export default class extends Controller {
  static targets = [ "gameTitle", "gameNewTitle", "playerName", "playerNewName"]

  connect() {
    console.log("Click edit controller connected");
  }

  click(event) {
    console.log(`Clicked on ${event.target.textContent}`);
    // Sets model & field to allow proper saving to the DB
    const model = event.currentTarget.getAttribute('data-model');
    console.log(`Model: ${model}`);
    const field = event.currentTarget.getAttribute('data-field');
    console.log(`Field: ${field}`);
    // Dynamic routes for different fields. Allows for easy expansion
    switch(field) {
      case "title":
        this.toggleEditing(this.gameTitleTarget, this.gameNewTitleTarget, model, field);
        break;
      case "name":
        this.toggleEditing(this.playerNameTarget, this.playerNewNameTarget, model, field);
        break;
    }
  }

  toggleEditing(oldContent, newContent, model, field) {
    oldContent.classList.add("d-none");
    newContent.classList.remove("d-none");
    newContent.focus();
    this.moveCursorToEnd(oldContent, newContent);
    // Closes and saves new content on outside clicks (blur) or enter key
    newContent.addEventListener("blur", () => {
      console.log("Blur event for", newContent);
      this.update(oldContent, newContent, model, field);
    });
    newContent.addEventListener("keydown", (event) => {
      if (event.key === "Enter") {
        console.log("Enter pressed for", newContent);
        this.update(oldContent, newContent, model, field);
      }
    });
  }

  // moves cursor from start of input to end of content for improved UI
  moveCursorToEnd(oldContent, newContent) {
    // Stores value for recall
    const value = oldContent.textContent
    console.log("Value:", value);
    // Clears input field
    newContent.value = "";
    // Restores value to field, now with cursor at the end
    newContent.value = value;
  }

  update(oldContent, newContent, model, field) {
    console.log("Update called for", field);
    // Saves new content
    const newValue = newContent.value.trim();
    console.log("New value:", newValue);
    // If no change, do nothing. Prevents unnecessary server calls
    if (newValue === oldContent.textContent.trim()) {
      this.closeEditing(oldContent, newContent);
      return;
    };
    // Sends new value to DB
    return this.save(model, field, newValue, oldContent)
      .then(response => {
        console.log(response)
        if (response.status === "Success") {
          console.log(response[model][field])
          oldContent.textContent = response[model][field];
          this.closeEditing(oldContent, newContent);
          console.log(`Updated ${field} to ${response[model][field]}`);
        } else {
          console.error("Error:", response);
        }
      })
      .catch(error => {
        console.error("Error:", error);
      })
  }

  save(model, field, newValue, oldContent) {
    //fetches url from the form to retrive model instance id
    const url = oldContent.getAttribute('data-url');
    console.log(url);
    // Retrieves the CSRF token from the meta tag (needs this to clear Rails inbuilt security)
    const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
    console.log(csrfToken);
    // Sends the new value to the server
    return fetch(url, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "X-CSRF-Token": csrfToken
      },
      body: JSON.stringify({ [model]: { [field]: newValue}})
    })
    .then(response => {
      if (!response.ok) {
        throw new Error("HTTP error, status = " + response.status);
      }
      return response.json();
    })
    .catch(error => console.error("Error:", error));
  }

  closeEditing(oldContent, newContent) {
    console.log("Close editing called");
    newContent.classList.add("d-none");
    oldContent.classList.remove("d-none");
  }
}
