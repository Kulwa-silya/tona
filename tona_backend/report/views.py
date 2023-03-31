import io
from django.http import FileResponse
from reportlab.pdfgen import canvas
from reportlab.lib.styles import ParagraphStyle
from reportlab.platypus import Paragraph, Spacer
from reportlab.lib.units import inch

# from store.models import Sale

def some_view(request):
    # Create a file-like buffer to receive PDF data.
    buffer = io.BytesIO()

    # Create the PDF object, using the buffer as its "file."
    p = canvas.Canvas(buffer)

    # p.translate(inch,inch)

    # Set the title style
    title_style = ParagraphStyle(
        'Title',
        fontName='Helvetica-Bold',
        fontSize=17,
        textColor='black',
        leading=18,
        alignment=1,
        spaceAfter=0.2*inch,
        spaceBefore=0.2*inch,
        textDecoration='underline'
    )

    # Set the subtitle style
    subtitle_style = ParagraphStyle(
        'Subtitle',
        fontName='Helvetica-Bold',
        fontSize=12,
        textColor='black',
        leading=16,
        alignment=1,
        spaceAfter=0.1*inch,
        spaceBefore=0.2*inch,
    )

    # Set the text style
    text_style = ParagraphStyle(
        'Text',
        fontName='Helvetica',
        fontSize=10,
        textColor='black',
        leading=14,
        alignment=0,
        spaceAfter=0.2*inch,
        spaceBefore=0.1*inch,
    )

    # Create the title paragraph
    title = Paragraph('Sales Report', title_style)
    title_width, title_height = title.wrap(p._pagesize[0], p._pagesize[1])
    title.drawOn(p, p._pagesize[0]/2 - title_width/2, p._pagesize[1] - title_height - 0.2*inch)

    # Create the subtitle paragraph with report duration
    subtitle = Paragraph('Duration: January 2022 - March 2022', subtitle_style)
    subtitle_width, subtitle_height = subtitle.wrap(p._pagesize[0], p._pagesize[1])
    subtitle.drawOn(p, p._pagesize[0]/2 - subtitle_width/2, p._pagesize[1] - title_height - subtitle_height - 0.3*inch)

    # Add a spacer
    spacer = Spacer(1, 0.2*inch)
    spacer.wrapOn(p, p._pagesize[0], p._pagesize[1])
    spacer.drawOn(p, 0, 0)

    # Add the sales graph
    # TODO: Add code to draw sales graph

    # Create the leading product title paragraph
    leading_product_title = Paragraph('Leading Selling Product', subtitle_style)
    leading_product_title_width, leading_product_title_height = leading_product_title.wrap(p._pagesize[0], p._pagesize[1])
    leading_product_title.drawOn(p, p._pagesize[0]/2 - leading_product_title_width/2, p._pagesize[1] - title_height - subtitle_height - spacer.height - 0.3*inch)

    # Add a spacer
    spacer = Spacer(1, 0.2*inch)
    spacer.wrapOn(p, p._pagesize[0], p._pagesize[1])
    spacer.drawOn(p, 0, 0)

    # Add the leading product graph
    # TODO: Add code to draw leading product graph

    # Close the PDF object cleanly, and we're done.
    p.showPage()
    p.save()

    # FileResponse sets the Content-Disposition header so that browsers
    # present the option to save the file.
    buffer.seek(0)
    return FileResponse(buffer, as_attachment=True, filename='hello.pdf')
