# DBReportPDF

---

Is a [Xojo/(Real Basic)](http://www.xojo.com) component for create PDF files.
Based on pdfFile by Toby W. Rush and [roblthegreat/rsfpdf](https://github.com/roblthegreat/rsfpdf).

[See on github](https://github.com/lbmonsalve/DBReportPDF/) v0.2.2817 by Bernardo Monsalve.

## Requirements

You can use in projects since RealStudio 2011r4 to Xojo 2016r4, desktop and console apps.

## Installation

Add Component/* files to your project.

## Use

Open `DBReportPDF Example.rbvcp` for RealStudio or `DBReportPDF Example.xojo_binary_project` for xojo.

See the Button PDF Action event for create PDF file.

### Some commands:

* Create a new object with default paper size (letter).

```vb
Dim pdf As New DBReportPDF
```

* Define properties.

```vb
pdf.Author= "Me, the author"
pdf.Title= "The title"
pdf.Subject= "someelse"
pdf.Keywords= "some keyword"
```

* Draw someting.

```vb
pdf.TextFont= "Times"
pdf.DrawString "Hello world", 100, 100, 50

pdf.DrawLine 20, 20, 40, 40

pdf.ForeColor= &c40004000
pdf.PenWidth= 2
pdf.DrawRect 20, 20, 20, 20

pdf.DrawOval 200, 20, 20, 20

pdf.DrawPicture SaveFile, 300, 40
```

* Create a new page.

```vb
pdf.NextPage
pdf.Landscape= True
```

* Save the pdf on a FolderItem.

```vb
Dim f as FolderItem= SpecialFolder.Desktop.Child("DBReportPDF test.pdf")
pdf.Save(f)
```

## Configuration

The file `DBReportShared` has a `kzlibPath` constant. That contains the location of zlib shared library for compression.

The ZLIB1.DLL file is for Windows SO, in macOS or linux you **need** install the 32bit version 
(except Xojo 64bit) or disable compression with `pdf.Compression= False`.