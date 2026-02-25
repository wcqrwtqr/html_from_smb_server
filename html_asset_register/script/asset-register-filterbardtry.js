$(document).ready(function () {

    // Clone header row for filters
    $('#pdfTable thead tr')
        .clone(true)
        .addClass('filters')
        .appendTo('#pdfTable thead');

    var table = $('#pdfTable').DataTable({
        orderCellsTop: true,
        fixedHeader: true,
        pageLength: 50,
        dom: 'Bfrtip',


        select: {
            style: 'multi' // Allow slickling on the rows to multi-select
        },



        buttons: [
            {
                extend: 'excelHtml5',
                text: 'Export Excel',
                className: 'btn btn-success'
            },
            {
                extend: 'pdfHtml5',
                text: 'Export PDF',
                className: 'btn btn-danger'
            },
        ],
        initComplete: function () {
            var api = this.api();

            api.columns().eq(0).each(function (colIdx) {
                var cell = $('.filters th').eq(colIdx);
                var title = $(cell).text();

                $(cell).html(
                    '<input type="text" class="form-control form-control-sm" placeholder="Search ' + title + '" />'
                );

                $('input', cell).on('keyup change', function (e) {
                    e.stopPropagation();

                    api.column(colIdx)
                        .search(this.value)
                        .draw();
                });
            });
        }
    });

    // Function to update button state
    function updateDownloadButtonState() {
        var selectedCount = table.rows({ selected: true }).count();
        if (selectedCount > 0) {
            $('#downloadSelected').prop('disabled', false);
            $('#downloadSelected').text('Download Selected (' + selectedCount + ')');
        } else {
            $('#downloadSelected').prop('disabled', true);
            $('#downloadSelected').text('Download Selected Assets Links');
        }
        // Listen for select and deselect events
        table.on('select deselect', function () {
            updateDownloadButtonState();
        });}

    // Logic for the Download Button
    $('#downloadSelected').on('click', function () {
        // Get data from selected rows
        var selectedData = table.rows({ selected: true }).nodes();
        var linksFound = [];

        // Loop through each selected row and find all <a> tags
        $(selectedData).each(function() {
            $(this).find('a').each(function() {
                var url = $(this).attr('href');
                if (url && url !== '#' && url !== '') {
                    linksFound.push(url);
                }
            });
        });

        if (linksFound.length === 0) {
            alert("No links found in the selected rows!");
            return;
        }

        // Trigger downloads
        if (confirm("You are about to download " + linksFound.length + " files. Continue?")) {
            linksFound.forEach(function(url, index) {
                // Use a timeout to prevent the browser from blocking multiple popups
                setTimeout(function() {
                    var link = document.createElement('a');
                    link.href = url;
                    link.target = '_blank';
                    // This attribute attempts to force download
                    link.download = url.split('/').pop(); 
                    document.body.appendChild(link);
                    link.click();
                    document.body.removeChild(link);
                }, index * 500); // 500ms delay between each download
            });
        }
    });

});
