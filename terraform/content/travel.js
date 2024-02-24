
console.log(travelPlaces);

    let tableHtml = `
        <table border="1" style="width: 55%">
            <thead>
                <tr>
                    <th>Country</th>
                    <th>City</th>
                    <th>Must See Places</th>
                </tr>
            </thead>
            <tbody>`;

    // Loop through the array and populate the table rows
    travelPlaces.forEach(place => {
        tableHtml += `
            <tr>
                <td>${place[1]}</td>
                <td>${place[2]}</td>
                <td>${place[3]}</td>
            </tr>`;
    });

    // Close the table
    tableHtml += `
            </tbody>
        </table>`;

    return tableHtml;
}

// Get the HTML element to display the table
const tableContainer = document.getElementById('table-container');

// Call the generateTable function and set the generated table HTML to the container
generateTable().then(html => {
    tableContainer.innerHTML = html;
});