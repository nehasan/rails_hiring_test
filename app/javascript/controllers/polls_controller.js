import { Controller } from "@hotwired/stimulus"
import { canadianCities } from "../lib/cities";
import axios from "axios";

// Connects to data-controller="polls"
export default class extends Controller {

  // Static targets to grab contents
  static targets = [
    'cityNamesCreate',
    'cityNamesEdit',
    'createPollForm',
    'editPollingLocationForm'
  ];

  /**
   * Method populates city select tag with with city names
   * The select city tag resides in create-poll-modal
   */
  setCityNames() {
    let optionHTML = '<option selected>Select City</>'
    canadianCities.forEach(element => {
      optionHTML += `<option value="${element}">${element}</>`
    });
    this.cityNamesCreateTarget.innerHTML = optionHTML;
    this.cityNamesEditTarget.innerHTML = optionHTML;
  }


  // Actions for create new poll
  /**
   * Method is used to pop up modal upon 'Add New Poll' button clicked
   */
  showNewPollModal() {
    document.querySelector('.create-poll-modal').style.display = 'block';
  }

  /**
   * Closes the modal once close button is clicked
   */
  closeNewPollModal() {
    document.querySelector('.create-poll-modal').style.display = 'none';
  }

  /**
   * Submits the form data to create a new poll
   * @param {*} event 
   */
  submitCreatePoll(event) {
    // Close the modal when action is done
    function closeModal () {
      document.querySelector('.create-poll-modal').style.display = 'none';
    }

    event.preventDefault();
    const formData = new FormData(this.createPollFormTarget);

    // Send form data using axios post method
    axios({
      method: "post",
      url: "/polls.json",
      data: formData,
      headers: { "Content-Type": "multipart/form-data" },
    }).then(function (response) {
        //handle success
        console.log(response);
        document.querySelector('.create-poll-err-msg').innerHTML = 'Poll created successfully';
        closeModal();
      })
      .catch(function (response) {
        //handle error
        console.log(response);
        document.querySelector('.create-poll-err-msg').innerHTML = response.message;
      });

  }

  // Actions for edit polling location
  /**
   * Event is used to show edit poll location modal
   */
  showEditPollingLocationModal(event) {
    /**
     * This method populates edit modal with selected polling location data
     * @param {*} id 
     */
    function populateModalWithData(id) {
      let titleVal = document.querySelector(`#title-${id}`).innerHTML,
          addressVal = document.querySelector(`#address-${id}`).innerHTML,
          cityVal = document.querySelector(`#city-${id}`).innerHTML,
          postalCodeVal = document.querySelector(`#postal_code-${id}`).innerHTML;

      document.querySelector('#polling-loc-id').value = id;
      document.querySelector('#title-edit').value = titleVal;
      document.querySelector('#address-edit').value = addressVal;
      document.querySelector('#city-edit').value = cityVal;
      document.querySelector('#postal_code-edit').value = postalCodeVal;
    }

    //Capture the <a> tag and it's data-id
    const dataId = event.currentTarget.dataset.id
    populateModalWithData(dataId);

    document.querySelector('.edit-poll-loc-modal').style.display = 'block';
  }

  /**
   * Event is used to clode edit poll location modal
   */
  closeEditPollingLocationModal() {
    setTimeout(() => {
      document.querySelector('.edit-poll-loc-modal').style.display = 'none';
    })
  }

  /**
   * Submits the form data to edit a poll location
   * @param {*} event 
   */
  submitEditPollingLocation(event) {
    // Close the modal when action is done
    function closeModal () {
      setTimeout(() => {
        document.querySelector('.edit-poll-loc-modal').style.display = 'none';
      }, 5000);
    }

    event.preventDefault();
    const id = document.querySelector('#polling-loc-id').value;
    const formData = new FormData(this.editPollingLocationFormTarget);

    // Send form data using axios put method
    axios({
      method: "put",
      url: `/polling_locations/${id}.json`,
      data: formData,
      headers: { "Content-Type": "multipart/form-data" },
    }).then(function (response) {
        //handle success
        // console.log(response);
        document.querySelector('.edit-poll-loc-msg').innerHTML = 'Polling Location updated successfully';
        closeModal();
      })
      .catch(function (response) {
        //handle error
        // console.log(response);
        document.querySelector('.edit-poll-loc-err-msg').innerHTML = response.message;
      });

  }

  connect() {
    console.log('PollsController connected!');

    // Initialize the city names for create-poll-modal
    this.setCityNames()
  }
}
