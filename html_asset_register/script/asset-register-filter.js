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

});
