#tag Class
Protected Class DBReportPDF
	#tag Method, Flags = &h0
		 Shared Sub AddFontFolder(f As FolderItem)
		  If f= Nil Then Return
		  
		  If Not f.Directory Then Return
		  
		  For i As Integer= 0 To DBReportPDFFont.FontFolders.Ubound
		    If DBReportPDFFont.FontFolders(i).URLPath= f.URLPath Then Return
		  Next
		  
		  DBReportPDFFont.FontFolders.Append f
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function AddPage() As DBReportPDFPageLeaf
		  Return AddPage(mPageWidth, mPageHeight)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function AddPage(width As Double, height As Double) As DBReportPDFPageLeaf
		  mPageWidth= width
		  mPageHeight= height
		  
		  Return ObjectCatalog.AddPage(width, height)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( Hidden )  Function CacheGetBaseFont(whichFontName As String, bold As Boolean, italic As Boolean) As String
		  Dim bf As String
		  
		  Select Case whichFontName
		  Case "Times"
		    If bold And Italic Then
		      bf= "Times-BoldItalic"
		    ElseIf bold Then
		      bf= "Times-Bold"
		    ElseIf italic Then
		      bf= "Times-Italic"
		    Else
		      bf= "Times-Roman"
		    End
		  Case "Helvetica", "System"
		    If bold And italic then
		      bf= "Helvetica-BoldOblique"
		    ElseIf bold Then
		      bf= "Helvetica-Bold"
		    ElseIf italic Then
		      bf= "Helvetica-Oblique"
		    Else
		      bf= "Helvetica"
		    End
		  Case "Courier"
		    if bold and italic then
		      bf="Courier-BoldOblique"
		    elseif bold then
		      bf="Courier-Bold"
		    elseif italic then
		      bf="Courier-Oblique"
		    else
		      bf="Courier"
		    end
		  Case "Symbol"
		    bf="Symbol"
		  Case "Zapf Dingbats"
		    bf="ZapfDingbats"
		  Case Else
		    #if TargetWin32
		      If CacheFontDescriptor<> Nil Then
		        Dim key As String= DBReportPDFFont.GetCacheKey(whichFontName, bold, italic)
		        If CacheFontDescriptor.HasKey(key) Then
		          Dim cacheDescriptor As DBReportPDFFontDescriptor= CacheFontDescriptor.Value(key)
		          bf= cacheDescriptor.FontName
		        Else
		          bf= DBReportPDFFont.GetCacheKey(whichFontName, bold, italic)
		        End
		      Else
		        bf= DBReportPDFFont.GetCacheKey(whichFontName, bold, italic)
		      End
		    #else
		      bf= DBReportPDFFont.GetCacheKey(whichFontName, bold, italic)
		    #endif
		  End Select
		  
		  Return bf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( Hidden )  Function CacheGetFontFile(fileName As String) As DBReportPDFFontFile
		  If CacheFontFiles.HasKey(fileName) Then
		    Return CacheFontFiles.Value(fileName)
		  End
		  
		  Return Nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( Hidden )  Function CacheGetFontFileHasKey(fileName As String) As Boolean
		  If CacheFontFiles.HasKey(fileName) Then
		    Return True
		  End
		  
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( Hidden )  Sub CacheSetFontDescriptor(key As String, descriptor As DBReportPDFFontDescriptor)
		  CacheFontDescriptor.Value(key)= descriptor
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( Hidden )  Sub CacheSetFontFile(fileName As String, file As DBReportPDFFontFile)
		  CacheFontFiles.Value(fileName)= file
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( Hidden )  Sub CacheSetFontWidths(key As String, widths As DBReportPDFFontWidths)
		  CacheFontWidths.Value(key)= widths
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ClearRect(x As Double, y As Double, width As Double, height As Double)
		  Dim cTmp As Color= ForeColor
		  ForeColor= &cFFFFFF00
		  DrawRect x, y, width, height
		  ForeColor= cTmp
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  mPageWidth= kPageWidth
		  mPageHeight= kPageHeight
		  
		  Init
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(width As Double, height As Double)
		  mPageWidth= width
		  mPageHeight= height
		  
		  Init
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ConvertCoordinates(points() As Double)
		  Dim i,n As Integer
		  
		  n= Ubound(points)
		  For i= 1 To n Step 2
		    points(i)= mPageHeight- points(i)
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( Hidden )  Function Data() As String
		  Dim i,n As Integer
		  Dim s As String
		  
		  'Add Info obj:
		  If Creator= "" Then Creator= App.ExecutableFile.DisplayName
		  ObjectInfo= New DBReportPDFInfo(Me)
		  
		  SetAllObjectNumbers
		  
		  n= Ubound(Objects)
		  If n> -1 Then
		    s= Header+ CR
		    
		    For i= 0 To n
		      Objects(i).byteOffset= len(s)
		      s= s+ Objects(i).DataStream+ CR
		    Next
		    
		    XrefLocation= len(s)
		    s= s+ Xref
		    s= s+ Trailer
		  End
		  
		  Return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DrawLine(x1 As Double, y1 As Double, x2 As Double, y2 As Double)
		  ObjectPageCurrent.AddLine x1, mPageHeight- y1, x2, mPageHeight- y2, PenWidth, ForeColor
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DrawOval(x As Double, y As Double, width As Double, height As Double)
		  ObjectPageCurrent.AddOval x, mPageHeight- y- height, width, height, penWidth, foreColor
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DrawPicture(image As Picture, x As Double, y As Double, destWidth As Double, destHeight As Double, Optional pictureQuality As Integer = 80)
		  Dim imageRef As String
		  
		  If image.depth<> 0 Then
		    imageRef= ObjectCatalog.Pages.GetImageReferenceName(image, 0, 0, image.width, image.height, pictureQuality)
		    
		    Dim ratio As Double = Min(destHeight/image.Height, destWidth/image.Width)
		    
		    ObjectPageCurrent.AddImage(imageRef, x, mPageHeight- y- image.Height* ratio, image.Width* ratio, image.Height* ratio)
		    
		    mCurrentBaseLine= y+ (image.Height* ratio)
		  End
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DrawPicture(image As Picture, x As Double, y As Double, Optional pictureQuality As Integer = 80)
		  Dim imageRef As String
		  
		  If image.depth<> 0 Then
		    imageRef= ObjectCatalog.Pages.GetImageReferenceName(image, 0, 0, image.Width, image.Height, pictureQuality)
		    ObjectPageCurrent.AddImage(imageRef, x, mPageHeight- y- image.height, image.width, image.height)
		    
		    mCurrentBaseLine= y+ image.height
		  End
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DrawPolygon(points() As Double)
		  ConvertCoordinates(points)
		  ObjectPageCurrent.AddPolygon points, penWidth, foreColor
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DrawRect(x As Double, y As Double, width As Double, height As Double)
		  ObjectPageCurrent.AddRect x, mPageHeight- y, width, height, PenWidth, ForeColor
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DrawRoundRect(x As Double, y As Double, width As Double, height As Double, ArcWidth As Double, ArcHeight As Double)
		  ObjectPageCurrent.AddRoundRect x, mPageHeight- y, width, height, ArcWidth, ArcHeight, penWidth, foreColor
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DrawString(text As String, x As Double, y As Double, Optional wrapWidth As Double, Optional condense As Boolean)
		  Dim fontRef, currentLine As String
		  Dim currentBaseline As Double
		  Dim i, n As Integer
		  
		  Static p As Picture
		  If p= Nil Then p= New Picture(10, 10, 1)
		  Dim g As Graphics= p.Graphics
		  g.TextFont= TextFont
		  g.TextSize= TextSize
		  g.Bold= Bold
		  g.Italic= Italic
		  g.Underline= Underline
		  mTextAscent= g.TextAscent
		  mTextHeight= g.TextHeight
		  
		  fontRef= ObjectCatalog.Pages.GetFontReferenceName(TextFont, Bold, Italic)
		  
		  currentBaseline= mPageHeight- y // currentBaseline is computed in PDF space (-y = down)
		  
		  If wrapWidth= 0 Then
		    n= CountFields(text, EndOfLine)
		    For i= 1 To n
		      currentLine= NthField(text, EndOfLine, i)
		      ObjectPageCurrent.AddText(currentLine, x, currentBaseline, fontRef, TextSize, ForeColor)
		      currentBaseline= currentBaseline- TextHeight
		    Next
		  Else
		    If condense Then
		      If g.StringWidth(text)> wrapWidth Then
		        For i= 1 To text.Len
		          If g.StringWidth(text.Left(i)+ "...")> wrapWidth Then Exit For i
		          currentLine= text.Left(i)+ "..."
		        Next
		        ObjectPageCurrent.AddText(currentLine, x, currentBaseline, fontRef, TextSize, ForeColor)
		      Else
		        ObjectPageCurrent.AddText(text, x, currentBaseline, fontRef, TextSize, ForeColor)
		      End
		    Else
		      Dim words() As String
		      
		      n= CountFields(ReplaceLineEndings(text, EndOfLine.Windows), EndOfLine.Windows)
		      For i= 1 To n
		        currentLine= NthField(ReplaceLineEndings(text, EndOfLine.Windows), EndOfLine.Windows, i)
		        If currentLine= "" Then
		          currentBaseline= currentBaseline- textHeight
		        End If
		        words= currentLine.Split(" ")
		        
		        While Ubound(words)> -1
		          currentLine=""
		          Do Until Ubound(words)= -1 Or g.StringWidth(currentLine+ " "+ words(0))>= wrapWidth
		            If currentLine="" Then
		              currentLine= words(0)
		            Else
		              currentLine= currentLine+ " "+ words(0)
		            end
		            words.Remove 0
		          loop
		          If currentLine= "" Then // if the next word is longer than wrapWidth
		            // this is where we should split the word among several lines, but for now...
		            currentLine= words(0) // ...we'll print it anyway even though it will overflow
		            words.remove 0
		          End
		          ObjectPageCurrent.AddText currentLine, x, currentBaseline, fontRef, textSize, foreColor
		          currentBaseline= currentBaseline- textHeight
		        Wend
		      Next
		    End
		  End
		  
		  mCurrentBaseLine= mPageHeight- currentBaseline+ textHeight
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DrawTextArea(texta As Object, x As Double, y As Double, width As Double, height As Double = - 1)
		  #if TargetConsole
		    #pragma Unused texta
		    #pragma Unused x
		    #pragma Unused y
		    #pragma Unused width
		    #pragma Unused height
		  #else
		    Dim txtArea As TextArea= TextArea(texta)
		    
		    If txtArea.Text= "" Then Return
		    
		    #pragma BackgroundTasks false // to speed up
		    
		    Dim st As StyledText= txtArea.StyledText
		    Dim stylesCount As Integer= st.StyleRunCount- 1
		    Dim sr As StyleRun
		    Dim fontRef, s As String
		    Dim CR As String= EndOfLine.Windows
		    Dim gtextHeight As Double
		    Dim currentLeft As Double= x
		    Dim currentBaseline As Double= mPageHeight- y
		    Dim currentMarginBottom As Double
		    Dim currentColor As Color= &cFFFFFFFF
		    Dim currentAlignment As Integer= -1
		    Dim currentLine As String
		    Dim currentLineNumber As Integer= 0
		    Dim lineFeed As Boolean= True
		    
		    Static p As Picture
		    If p= Nil Then p= New Picture(1, 1, 1)
		    Dim g As Graphics= p.Graphics
		    
		    // ini calc maxTextHeight TODO: calc left ini for center and right align
		    Dim dTextH As Dictionary= New Dictionary // height of line
		    Dim dTextW As Dictionary= New Dictionary // width of line
		    Dim dTextL As Dictionary= New Dictionary // left of line
		    For i As Integer= 0 To stylesCount
		      sr= st.StyleRun(i)
		      
		      g.TextFont= sr.Font // "Arial"
		      g.TextSize= sr.Size
		      g.Bold= sr.Bold
		      g.Italic= sr.Italic
		      gTextHeight= g.TextHeight
		      
		      Dim t As String= ReplaceLineEndings(sr.Text, EndOfLine.Macintosh)
		      Dim n As Integer= CountFields(t, EndOfLine.Macintosh)
		      
		      For j As Integer= 1 To n
		        currentLine= NthField(t, EndOfLine.Macintosh, j)
		        If currentLine= "" And j<> n Then // just endofline
		          currentLineNumber= currentLineNumber+ 1
		          dTextH.Value(currentLineNumber)= gTextHeight
		          dTextW.Value(currentLineNumber)= 0
		          Continue
		        End If
		        
		        If lineFeed Then
		          currentLineNumber= currentLineNumber+ 1
		          lineFeed= False
		        End If
		        
		        If (currentLeft+ g.StringWidth(currentLine))<= (x+ width) Then // one line
		          If dTextH.HasKey(currentLineNumber) Then
		            Dim tTextHeight As Double= dTextH.Value(currentLineNumber)
		            If gTextHeight> tTextHeight Then dTextH.Value(currentLineNumber)= gTextHeight
		          Else
		            dTextH.Value(currentLineNumber)= gTextHeight
		          End If
		          If dTextW.HasKey(currentLineNumber) Then
		            Dim tTextW As Double= dTextW.Value(currentLineNumber)
		            dTextW.Value(currentLineNumber)= tTextW+ g.StringWidth(currentLine)
		          Else
		            dTextW.Value(currentLineNumber)= g.StringWidth(currentLine)
		          End If
		          dTextL.Value(i)= currentLeft- x
		        Else
		          Dim words() As String= currentLine.Split(" ")
		          currentLine= ""
		          
		          While Ubound(words)> -1
		            If (currentLeft+ g.StringWidth(currentLine+ words(0)))<= (x+ width) Then
		              If currentLine= "" Then currentLine= words(0) Else currentLine= currentLine+ " "+ words(0)
		              words.Remove 0
		              If Ubound(words)= -1 Then
		                If dTextW.HasKey(currentLineNumber) Then
		                  Dim tTextW As Double= dTextW.Value(currentLineNumber)
		                  dTextW.Value(currentLineNumber)= tTextW+ g.StringWidth(currentLine)
		                Else
		                  dTextW.Value(currentLineNumber)= g.StringWidth(currentLine)
		                End If
		                dTextL.Value(i)= currentLeft- x
		              End If
		            Else
		              // TODO: chk for long word
		              If dTextH.HasKey(currentLineNumber) Then
		                Dim tTextHeight As Double= dTextH.Value(currentLineNumber)
		                If gTextHeight> tTextHeight Then dTextH.Value(currentLineNumber)= gTextHeight
		              Else
		                dTextH.Value(currentLineNumber)= gTextHeight
		              End If
		              If dTextW.HasKey(currentLineNumber) Then
		                Dim tTextW As Double= dTextW.Value(currentLineNumber)
		                dTextW.Value(currentLineNumber)= tTextW+ g.StringWidth(currentLine)
		              Else
		                dTextW.Value(currentLineNumber)= g.StringWidth(currentLine)
		              End If
		              dTextL.Value(i)= currentLeft- x
		              
		              currentLine= ""
		              currentLeft= x
		              currentLineNumber= currentLineNumber+ 1
		            End If
		          Wend
		        End If
		        
		        If j< n Then
		          currentLeft= x
		          lineFeed= True
		        Else
		          currentLeft= currentLeft+ g.StringWidth(currentLine)
		        End If
		      Next
		    Next
		    currentLeft= x
		    currentLineNumber= 0
		    // end calc maxTextHeight
		    
		    lineFeed= True
		    
		    If height= -1 Then currentMarginBottom= 50 Else currentMarginBottom= mPageHeight- y- height
		    
		    s= "BT"+ CR // begin text block
		    
		    For i As Integer= 0 To stylesCount
		      sr= st.StyleRun(i)
		      
		      fontRef= ObjectCatalog.Pages.GetFontReferenceName(sr.Font, sr.Bold, sr.Italic) // "Helvetica"
		      
		      s= s+ "/"+ fontRef+ " "+ DBReportPDFObject.fs(sr.Size)+ " Tf"+ CR
		      
		      If currentColor<> sr.TextColor Then
		        currentColor= sr.TextColor
		        s= s+ DBReportPDFContents.GetRGBTriplet(currentColor)+ " RG"+ CR // set stroking color
		        s= s+ DBReportPDFContents.GetRGBTriplet(currentColor)+ " rg"+ CR // set non-stroking color
		      End If
		      
		      g.TextFont= sr.Font // "Arial"
		      g.TextSize= sr.Size
		      g.Bold= sr.Bold
		      g.Italic= sr.Italic
		      gtextHeight= g.TextHeight
		      
		      Dim t As String= ReplaceLineEndings(sr.Text, EndOfLine.Macintosh)
		      Dim n As Integer= CountFields(t, EndOfLine.Macintosh)
		      
		      For j As Integer= 1 To n
		        currentLine= NthField(t, EndOfLine.Macintosh, j)
		        If currentLine= "" And j<> n Then // just endofline
		          currentLineNumber= currentLineNumber+ 1
		          If dTextH.HasKey(currentLineNumber) Then gTextHeight= dTextH.Value(currentLineNumber)
		          currentBaseline= currentBaseline- gTextHeight
		          If currentBaseline< currentMarginBottom Then
		            s= s+ "ET"+ CR // end text blocl
		            ObjectPageCurrent.AddTextBlock s
		            NextPage
		            s= "BT"+ CR // begin text block
		            s= s+ "/"+ fontRef+ " "+ DBReportPDFObject.fs(sr.Size)+ " Tf"+ CR
		            currentBaseline= mPageHeight- y
		          End If
		          currentLeft= x
		          Continue
		        End
		        
		        If lineFeed Then
		          currentLineNumber= currentLineNumber+ 1
		          If dTextH.HasKey(currentLineNumber) Then gTextHeight= dTextH.Value(currentLineNumber)
		          currentBaseline= currentBaseline- gTextHeight
		          If currentBaseline< currentMarginBottom Then
		            s= s+ "ET"+ CR // end text blocl
		            ObjectPageCurrent.AddTextBlock s
		            NextPage
		            s= "BT"+ CR // begin text block
		            s= s+ "/"+ fontRef+ " "+ DBReportPDFObject.fs(sr.Size)+ " Tf"+ CR
		            currentBaseline= mPageHeight- y
		          End If
		          lineFeed= False
		        End If
		        
		        // check the alignment using the Paragraph list
		        Dim alignment As Integer= 0
		        Dim pc As Integer= st.ParagraphCount- 1
		        For pi As Integer= 0 To pc
		          Dim pa As Paragraph= st.Paragraph(pi)
		          'Dim ra As Range= st.StyleRunRange(i)
		          'If pa.StartPos<= ra.StartPos Then
		          '#if Not TargetLinux then
		          'alignment= pa.Alignment
		          '#endif
		          'End
		          Dim rn As DatabaseRecord= InStrRangeEOL(sr.Text, st.StyleRunRange(i), j)
		          If rn.IntegerColumn("StartPos")>= pa.StartPos And rn.IntegerColumn("EndPos")<= pa.EndPos Then
		            #if Not TargetLinux
		              alignment= pa.Alignment
		              Exit For pi
		            #endif
		          End
		        Next
		        
		        // apply alignment
		        If currentAlignment<> alignment Then
		          currentAlignment= alignment
		          currentLeft= x
		        End if
		        
		        If (currentLeft+ g.StringWidth(currentLine))<= (x+ width) Then // one line
		          
		          // check alignment
		          Select case alignment
		          case TextArea.AlignCenter
		            Dim tTextW As Double= dTextW.Value(currentLineNumber)
		            Dim tTextL As Double= dTextL.Value(i)
		            currentLeft= x+ ((width- tTextW)/ 2)+ tTextL // TODO: wrong g.StringWidth(currentLine)
		          case TextArea.AlignRight
		            Dim tTextW As Double= dTextW.Value(currentLineNumber)
		            Dim tTextL As Double= dTextL.Value(i)
		            currentLeft= x+ width- tTextW+ tTextL // TODO: wrong g.StringWidth(currentLine)
		          else // Left
		          end Select
		          
		          s= s+ "1 0 0 1 "+ DBReportPDFObject.fs(currentLeft)+ " "+ DBReportPDFObject.fs(currentBaseline)+ " Tm"+ CR
		          s= s+ DBReportPDFObject.FormatLiteralString(currentLine)+ " Tj"+ CR
		        Else // multiline
		          Dim words() As String= currentLine.Split(" ")
		          currentLine= ""
		          
		          While Ubound(words)> -1
		            If (currentLeft+ g.StringWidth(currentLine+ words(0)))<= (x+ width) Then
		              If currentLine= "" Then currentLine= words(0) Else currentLine= currentLine+ " "+ words(0)
		              words.Remove 0
		              If Ubound(words)= -1 Then
		                s= s+ "1 0 0 1 "+ DBReportPDFObject.fs(currentLeft)+ " "+ DBReportPDFObject.fs(currentBaseline)+ " Tm"+ CR
		                s= s+ DBReportPDFObject.FormatLiteralString(currentLine)+ " Tj"+ CR
		              End If
		            Else
		              // TODO: chk for long word
		              If alignment< 2 Then
		                Dim jWords() As String= currentLine.Split(" ") // justified words
		                Dim jWordsN As Integer= UBound(jWords)  // justified words number
		                Dim jWordsWidth, jWordsSpace As Double
		                For ji As Integer= 0 To jWordsN
		                  jWordsWidth= jWordsWidth+ g.StringWidth(jWords(ji))
		                Next
		                jWordsSpace= (width- jWordsWidth)/ jWordsN
		                For ji As Integer= 0 To jWordsN
		                  s= s+ "1 0 0 1 "+ DBReportPDFObject.fs(currentLeft)+ " "+ DBReportPDFObject.fs(currentBaseline)+ " Tm"+ CR
		                  s= s+ DBReportPDFObject.FormatLiteralString(jWords(ji))+ " Tj"+ CR
		                  If ji< jWordsN Then currentLeft= currentLeft+ g.StringWidth(jWords(ji))+ jWordsSpace Else currentLeft= currentLeft+ g.StringWidth(jWords(ji))
		                Next
		              Else
		                s= s+ "1 0 0 1 "+ DBReportPDFObject.fs(currentLeft)+ " "+ DBReportPDFObject.fs(currentBaseline)+ " Tm"+ CR
		                s= s+ DBReportPDFObject.FormatLiteralString(currentLine)+ " Tj"+ CR
		              End
		              currentLine= ""
		              currentLeft= x
		              currentLineNumber= currentLineNumber+ 1
		              If dTextH.HasKey(currentLineNumber) Then gTextHeight= dTextH.Value(currentLineNumber)
		              currentBaseline= currentBaseline- gTextHeight
		              If currentBaseline< currentMarginBottom Then
		                s= s+ "ET"+ CR // end text blocl
		                ObjectPageCurrent.AddTextBlock s
		                NextPage
		                s= "BT"+ CR // begin text block
		                s= s+ "/"+ fontRef+ " "+ DBReportPDFObject.fs(sr.Size)+ " Tf"+ CR
		                currentBaseline= mPageHeight- y
		              End If
		            End If
		          Wend
		        End If
		        
		        If j< n Then
		          currentLeft= x
		          lineFeed= True
		        Else
		          currentLeft= currentLeft+ g.StringWidth(currentLine)
		        End If
		        
		      Next
		      
		    Next
		    
		    s= s+ "ET"+ CR // end text block
		    
		    ObjectPageCurrent.AddTextBlock s
		    
		    mCurrentBaseLine= mPageHeight- currentBaseline
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DrawTextAreaAsImage(texta As Object, x As Double, y As Double, width As Double, height As Double = - 1)
		  #if TargetConsole
		    #pragma Unused texta
		    #pragma Unused x
		    #pragma Unused y
		    #pragma Unused width
		    #pragma Unused height
		  #else
		    Dim txtArea As TextArea= TextArea(texta)
		    
		    If txtArea.Text= "" Then Return
		    
		    #pragma BackgroundTasks false // to speed up
		    
		    Dim scale As Double= 2.0
		    
		    Dim st As StyledText= txtArea.StyledText
		    Dim stylesCount As Integer= st.StyleRunCount- 1
		    Dim sr As StyleRun
		    Dim gtextHeight As Double
		    Dim currentLeft As Double= x* scale
		    Dim currentBaseline As Double= y* scale
		    Dim currentMarginBottom As Double
		    Dim currentColor As Color= &cFFFFFFFF
		    Dim currentAlignment As Integer= -1
		    Dim currentLine As String
		    Dim currentLineNumber As Integer= 0
		    Dim lineFeed As Boolean= True
		    
		    Static p As Picture
		    If p= Nil Then p= New Picture(mPageWidth* scale, mPageHeight* scale, 32)
		    Dim g As Graphics= p.Graphics
		    g.ForeColor= &cFFFFFF00
		    g.FillRect 0, 0, g.Width, g.Height
		    
		    // ini calc maxTextHeight TODO: calc left ini for center and right align
		    Dim dTextH As Dictionary= New Dictionary // height of line
		    Dim dTextW As Dictionary= New Dictionary // width of line
		    Dim dTextL As Dictionary= New Dictionary // left of line
		    For i As Integer= 0 To stylesCount
		      sr= st.StyleRun(i)
		      
		      g.TextFont= sr.Font // "Arial"
		      g.TextSize= sr.Size* scale
		      g.Bold= sr.Bold
		      g.Italic= sr.Italic
		      gTextHeight= g.TextHeight
		      
		      Dim t As String= ReplaceLineEndings(sr.Text, EndOfLine.Macintosh)
		      Dim n As Integer= CountFields(t, EndOfLine.Macintosh)
		      
		      For j As Integer= 1 To n
		        currentLine= NthField(t, EndOfLine.Macintosh, j)
		        If currentLine= "" And j<> n Then // just endofline
		          currentLineNumber= currentLineNumber+ 1
		          dTextH.Value(currentLineNumber)= gTextHeight
		          dTextW.Value(currentLineNumber)= 0
		          Continue
		        End If
		        
		        If lineFeed Then
		          currentLineNumber= currentLineNumber+ 1
		          lineFeed= False
		        End If
		        
		        If (currentLeft+ g.StringWidth(currentLine))<= (x+ width)* scale Then // one line
		          If dTextH.HasKey(currentLineNumber) Then
		            Dim tTextHeight As Double= dTextH.Value(currentLineNumber)
		            If gTextHeight> tTextHeight Then dTextH.Value(currentLineNumber)= gTextHeight
		          Else
		            dTextH.Value(currentLineNumber)= gTextHeight
		          End If
		          If dTextW.HasKey(currentLineNumber) Then
		            Dim tTextW As Double= dTextW.Value(currentLineNumber)
		            dTextW.Value(currentLineNumber)= tTextW+ g.StringWidth(currentLine)
		          Else
		            dTextW.Value(currentLineNumber)= g.StringWidth(currentLine)
		          End If
		          dTextL.Value(i)= currentLeft- (x* scale)
		        Else
		          Dim words() As String= currentLine.Split(" ")
		          currentLine= ""
		          
		          While Ubound(words)> -1
		            If (currentLeft+ g.StringWidth(currentLine+ words(0)))<= (x+ width)* scale Then
		              If currentLine= "" Then currentLine= words(0) Else currentLine= currentLine+ " "+ words(0)
		              words.Remove 0
		              If Ubound(words)= -1 Then
		                If dTextW.HasKey(currentLineNumber) Then
		                  Dim tTextW As Double= dTextW.Value(currentLineNumber)
		                  dTextW.Value(currentLineNumber)= tTextW+ g.StringWidth(currentLine)
		                Else
		                  dTextW.Value(currentLineNumber)= g.StringWidth(currentLine)
		                End If
		                dTextL.Value(i)= currentLeft- (x* scale)
		              End If
		            Else
		              // TODO: chk for long word
		              If dTextH.HasKey(currentLineNumber) Then
		                Dim tTextHeight As Double= dTextH.Value(currentLineNumber)
		                If gTextHeight> tTextHeight Then dTextH.Value(currentLineNumber)= gTextHeight
		              Else
		                dTextH.Value(currentLineNumber)= gTextHeight
		              End If
		              If dTextW.HasKey(currentLineNumber) Then
		                Dim tTextW As Double= dTextW.Value(currentLineNumber)
		                dTextW.Value(currentLineNumber)= tTextW+ g.StringWidth(currentLine)
		              Else
		                dTextW.Value(currentLineNumber)= g.StringWidth(currentLine)
		              End If
		              dTextL.Value(i)= currentLeft- (x* scale)
		              
		              currentLine= ""
		              currentLeft= x* scale
		              currentLineNumber= currentLineNumber+ 1
		            End If
		          Wend
		        End If
		        
		        If j< n Then
		          currentLeft= x* scale
		          lineFeed= True
		        Else
		          currentLeft= currentLeft+ g.StringWidth(currentLine)
		        End If
		      Next
		    Next
		    currentLeft= x* scale
		    currentLineNumber= 0
		    // end calc maxTextHeight
		    
		    lineFeed= True
		    
		    If height= -1 Then currentMarginBottom= (mPageHeight- 50)* scale Else _
		    currentMarginBottom= (mPageHeight- y- height)* scale
		    
		    For i As Integer= 0 To stylesCount
		      sr= st.StyleRun(i)
		      
		      If currentColor<> sr.TextColor Then
		        currentColor= sr.TextColor
		      End If
		      
		      g.ForeColor= sr.TextColor
		      g.TextFont= sr.Font // "Arial"
		      g.TextSize= sr.Size* scale
		      g.Bold= sr.Bold
		      g.Italic= sr.Italic
		      gtextHeight= g.TextHeight
		      
		      Dim t As String= ReplaceLineEndings(sr.Text, EndOfLine.Macintosh)
		      Dim n As Integer= CountFields(t, EndOfLine.Macintosh)
		      
		      For j As Integer= 1 To n
		        currentLine= NthField(t, EndOfLine.Macintosh, j)
		        If currentLine= "" And j<> n Then // just endofline
		          currentLineNumber= currentLineNumber+ 1
		          If dTextH.HasKey(currentLineNumber) Then gTextHeight= dTextH.Value(currentLineNumber)
		          currentBaseline= currentBaseline+ gTextHeight
		          If currentBaseline> currentMarginBottom Then
		            DrawPicture p, 0, 0, mPageWidth, mPageHeight
		            NextPage
		            Dim oldColor As Color= g.ForeColor
		            g.ForeColor= &cFFFFFF00
		            g.FillRect 0, 0, g.Width, g.Height
		            g.ForeColor= oldColor
		            currentBaseline= y* scale
		          End If
		          currentLeft= x* scale
		          Continue
		        End
		        
		        If lineFeed Then
		          currentLineNumber= currentLineNumber+ 1
		          If dTextH.HasKey(currentLineNumber) Then gTextHeight= dTextH.Value(currentLineNumber)
		          currentBaseline= currentBaseline+ gTextHeight
		          If currentBaseline> currentMarginBottom Then
		            DrawPicture p, 0, 0, mPageWidth, mPageHeight
		            NextPage
		            Dim oldColor As Color= g.ForeColor
		            g.ForeColor= &cFFFFFF00
		            g.FillRect 0, 0, g.Width, g.Height
		            g.ForeColor= oldColor
		            currentBaseline= y* scale
		          End If
		          lineFeed= False
		        End If
		        
		        // check the alignment using the Paragraph list
		        Dim alignment As Integer= 0
		        Dim pc As Integer= st.ParagraphCount- 1
		        For pi As Integer= 0 To pc
		          Dim pa As Paragraph= st.Paragraph(pi)
		          Dim rn As DatabaseRecord= InStrRangeEOL(sr.Text, st.StyleRunRange(i), j)
		          If rn.IntegerColumn("StartPos")>= pa.StartPos And rn.IntegerColumn("EndPos")<= pa.EndPos Then
		            #if Not TargetLinux
		              alignment= pa.Alignment
		              Exit For pi
		            #endif
		          End
		        Next
		        
		        // apply alignment
		        If currentAlignment<> alignment Then
		          currentAlignment= alignment
		          currentLeft= x* scale
		        End if
		        
		        If (currentLeft+ g.StringWidth(currentLine))<= (x+ width)* scale Then // one line
		          
		          // check alignment
		          Select case alignment
		          case TextArea.AlignCenter
		            Dim tTextW As Double= dTextW.Value(currentLineNumber)
		            Dim tTextL As Double= dTextL.Value(i)
		            currentLeft= (x* scale)+ (((width* scale)- tTextW)/ 2)+ tTextL // TODO: wrong g.StringWidth(currentLine)
		          case TextArea.AlignRight
		            Dim tTextW As Double= dTextW.Value(currentLineNumber)
		            Dim tTextL As Double= dTextL.Value(i)
		            currentLeft= ((x+ width)* scale)- tTextW+ tTextL // TODO: wrong g.StringWidth(currentLine)
		          else // Left
		          end Select
		          // Draw currentLeft, currentBaseline, currentLine
		          g.DrawString currentLine, currentLeft, currentBaseline
		        Else // multiline
		          Dim words() As String= currentLine.Split(" ")
		          currentLine= ""
		          
		          While Ubound(words)> -1
		            If (currentLeft+ g.StringWidth(currentLine+ words(0)))<= (x+ width)* scale Then
		              If currentLine= "" Then currentLine= words(0) Else currentLine= currentLine+ " "+ words(0)
		              words.Remove 0
		              If Ubound(words)= -1 Then
		                // Draw currentLeft, currentBaseline, currentLine
		                g.DrawString currentLine, currentLeft, currentBaseline
		              End If
		            Else
		              // TODO: chk for long word
		              If alignment< 2 Then
		                Dim jWords() As String= currentLine.Split(" ") // justified words
		                Dim jWordsN As Integer= UBound(jWords)  // justified words number
		                Dim jWordsWidth, jWordsSpace As Double
		                For ji As Integer= 0 To jWordsN
		                  jWordsWidth= jWordsWidth+ g.StringWidth(jWords(ji))
		                Next
		                jWordsSpace= ((width* scale)- jWordsWidth)/ jWordsN
		                For ji As Integer= 0 To jWordsN
		                  // Draw currentLeft, currentBaseline, jWords(ji)
		                  g.DrawString jWords(ji), currentLeft, currentBaseline
		                  If ji< jWordsN Then currentLeft= currentLeft+ g.StringWidth(jWords(ji))+ jWordsSpace Else currentLeft= currentLeft+ g.StringWidth(jWords(ji))
		                Next
		              Else
		                // Draw currentLeft, currentBaseline, jWords(ji)
		                g.DrawString currentLine, currentLeft, currentBaseline
		              End
		              currentLine= ""
		              currentLeft= x* scale
		              currentLineNumber= currentLineNumber+ 1
		              If dTextH.HasKey(currentLineNumber) Then gTextHeight= dTextH.Value(currentLineNumber)
		              currentBaseline= currentBaseline+ gTextHeight
		              If currentBaseline> currentMarginBottom Then
		                DrawPicture p, 0, 0, mPageWidth, mPageHeight
		                NextPage
		                Dim oldColor As Color= g.ForeColor
		                g.ForeColor= &cFFFFFF00
		                g.FillRect 0, 0, g.Width, g.Height
		                g.ForeColor= oldColor
		                currentBaseline= y* scale
		              End If
		            End If
		          Wend
		        End If
		        
		        If j< n Then
		          currentLeft= x* scale
		          lineFeed= True
		        Else
		          currentLeft= currentLeft+ g.StringWidth(currentLine)
		        End If
		        
		      Next
		      
		    Next
		    
		    DrawPicture p, 0, 0, mPageWidth, mPageHeight
		    
		    mCurrentBaseLine= currentBaseline/ scale
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FillOval(x As Double, y As Double, width As Double, height As Double)
		  ObjectPageCurrent.AddFilledOval x, mPageHeight- y- height, width, height, penWidth, foreColor
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FillPolygon(points() As Double)
		  ConvertCoordinates points
		  ObjectPageCurrent.AddFilledPolygon points, penWidth, foreColor
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FillRect(x As Double, y As Double, width As Double, height As Double)
		  ObjectPageCurrent.AddFilledRect x, mPageHeight- y- height, width, height, penWidth, foreColor
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FillRoundRect(x As Double, y As Double, width As Double, height As Double, ArcWidth As Double, ArcHeight As Double)
		  ObjectPageCurrent.AddFilledRoundRect x, mPageHeight- y- height, width, height, ArcWidth, ArcHeight, penWidth, foreColor
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FirstPage() As Integer
		  Return 1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetCurrentBaseLine() As Double
		  Return mCurrentBaseLine
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Header() As string
		  Return "%PDF-"+ VersionPDF+ CR+ "%"+ _
		  Encodings.ASCII.Chr(226)+ Encodings.ASCII.Chr(227)+ Encodings.ASCII.Chr(207)+ Encodings.ASCII.Chr(211)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Init()
		  #If TargetWin32 And Not TargetConsole
		    App.UseGDIPlus = True
		  #endif
		  
		  'Constants:
		  CR= EndOfLine.Macintosh
		  
		  mPageSizeOriginal= New REALbasic.Point(mPageWidth, mPageHeight)
		  
		  'Add Catalog obj:
		  ObjectCatalog= New DBReportPDFCatalog(Me)
		  ObjectPageCurrent= AddPage
		  
		  'Add Outlines obj:
		  
		  'Set metrics:
		  mTextAscent= 10
		  mTextHeight= TextSize
		  
		  If CacheFontDescriptor= Nil Then CacheFontDescriptor= New Dictionary
		  If CacheFontWidths= Nil Then CacheFontWidths= New Dictionary
		  If CacheFontFiles= Nil Then CacheFontFiles= New Dictionary
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function InStrRangeEOL(source As String, ra As Range, nth As Integer) As DatabaseRecord
		  Dim ret As New DatabaseRecord
		  ret.IntegerColumn("StartPos")= ra.StartPos
		  ret.IntegerColumn("Length")= ra.Length
		  ret.IntegerColumn("EndPos")= ra.EndPos
		  
		  If source.InStr(EndOfLine.Macintosh)= 0 Then Return ret
		  
		  Dim le As Integer= source.Len
		  Dim cNth As Integer
		  Dim found As Boolean
		  
		  For i As Integer= 1 To le
		    If source.Mid(i, 1)= EndOfLine.Macintosh Then
		      cNth= cNth+ 1
		      If cNth= nth Then
		        ret.IntegerColumn("EndPos")= ra.StartPos+ i- 1
		        found= True
		        Exit For
		      Else
		        ret.IntegerColumn("StartPos")= ra.StartPos+ i
		      End
		    End
		  Next
		  
		  If found Then
		    ret.IntegerColumn("Length")= ret.IntegerColumn("EndPos")- ret.IntegerColumn("StartPos")
		  End
		  
		  Return ret
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LastPage() As Integer
		  Return 999999
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function NewUID() As String
		  Return EncodeHex(MD5(Format(Microseconds, "000000000000000.000000")+ Str(Rnd)))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub NextPage()
		  ObjectPageCurrent= AddPage
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function PadLeft(whichNum as integer, length as integer) As string
		  Dim s As string
		  
		  For i As Integer=1 To length
		    s= s+ "0"
		  Next
		  
		  Return Format(whichNum, s)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Save(f As FolderItem)
		  If f<> Nil Then
		    Dim b as BinaryStream= BinaryStream.Create(f, True)
		    b.Write Data
		    b.Close
		  End
		  
		Exception IOException
		  Return
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SetAllObjectNumbers()
		  Dim i,n As Integer
		  
		  n= Ubound(Objects)
		  
		  If n> -1 Then
		    For i= 0 To n
		      Objects(i).Number= i+ 1
		    Next
		  End
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function StringHeight(Text As String, WrapWidth As Double) As Double
		  Dim p As New Picture(10, 10, 1)
		  Dim g As Graphics= p.Graphics
		  g.TextFont= TextFont
		  g.TextSize= TextSize
		  g.Bold= Bold
		  g.Italic= Italic
		  g.Underline= Underline
		  
		  Return g.StringHeight(text, wrapWidth)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function StringWidth(text As String) As Double
		  Dim p As New Picture(10, 10, 1)
		  Dim g As Graphics= p.Graphics
		  g.TextFont= TextFont
		  g.TextSize= TextSize
		  g.Bold= Bold
		  g.Italic= Italic
		  g.Underline= Underline
		  
		  Return g.StringWidth(text)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Trailer() As string
		  Dim s As String
		  
		  s= "trailer"+ CR
		  s= s+ "<<"
		  s= s+ "/Size "+ Str(Ubound(Objects)+ 2)
		  s= s+ "/Root "+ ObjectCatalog.IndirectReference
		  If ObjectInfo<> Nil Then
		    s= s+ "/Info "+ ObjectInfo.IndirectReference
		  End
		  s= s+ "/ID [<"+ NewUID+ "> <"+ NewUID+ ">]"
		  s= s+ ">>"+ CR
		  s= s+ "startxref"+ CR
		  s= s+ Str(XrefLocation)+ CR
		  s= s+ "%%EOF"
		  
		  Return s
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Xref() As string
		  Dim i,n As Integer
		  Dim s As string
		  
		  n= Ubound(Objects)
		  
		  If n> -1 Then
		    s= "xref"+ CR
		    s= s+ "0 "+Str(n+ 2)+ " "+ CR
		    s= s+ "0000000000 65535 f "+ CR
		    
		    For i= 0 To n
		      s= s+ PadLeft(Objects(i).ByteOffset, 10)+ " 00000 n "+ CR
		    Next
		  End
		  
		  Return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function zlibCompress(input as String) As String
		  Soft Declare Function zlibcompress Lib DBReportShared.kzlibPath Alias "compress" (dest As Ptr, ByRef destLen As Uint32, source As CString, sourceLen As UInt32) As Int32
		  
		  zlibLastErrorCode= 0
		  
		  Dim output As New MemoryBlock(12+ 1.002* LenB(input))
		  Dim outputSize As UInt32= output.Size
		  
		  zlibLastErrorCode= zlibcompress(output, outputSize, input, LenB(input))
		  
		  #if RBVersion> 2017.01
		    #if Target64Bit
		      Dim err As Integer= zlibcompress(output, outputSize, input, LenB(input))
		    #endif
		  #endif
		  
		  If zlibLastErrorCode= 0 Then
		    Return output.StringValue(0, outputSize)
		  Else
		    Return input
		  End
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function zlibUncompress(input as String, bufferSize as Integer = 0) As String
		  Soft Declare Function zlibuncompress Lib DBReportShared.kzlibPath Alias "uncompress" (dest As Ptr, ByRef destLen As UInt32, source As CString, sourceLen As Uint32) As Integer
		  
		  zlibLastErrorCode= 0
		  
		  If bufferSize= 0 Then
		    bufferSize= 4* LenB(input)
		  End
		  
		  Do
		    Dim m As New MemoryBlock(bufferSize)
		    Dim destLength As UInt32= m.Size
		    zlibLastErrorCode= zlibuncompress(m, destLength, input, LenB(input))
		    
		    #if RBVersion> 2017.01
		      #if Target64Bit
		        Dim err As Integer= zlibuncompress(m, destLength, input, LenB(input))
		      #endif
		    #endif
		    
		    If zlibLastErrorCode= 0 Then
		      Return m.StringValue(0, destLength)
		    ElseIf zlibLastErrorCode= Z_BUF_ERROR Then
		      bufferSize= bufferSize+ bufferSize
		    Else
		      Return ""
		    End if
		  Loop
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function zlibVersion() As String
		  Soft Declare Function zlibVersion Lib DBReportShared.kzlibPath () As Ptr
		  
		  Dim mb As MemoryBlock= zlibVersion
		  If mb<> Nil Then
		    Return mb.CString(0)
		  Else
		    Return ""
		  End if
		End Function
	#tag EndMethod


	#tag Note, Name = Readme
		DBReportPDF v0.2.4201
		
		Based on pdfFile by Toby W. Rush and rsfpdf from https://github.com/roblthegreat/rsfpdf
		
		by Bernardo Monsalve Copyright © 2014-2015 Bernardo Monsalve. All rights reserved.
		
		Version changelog:
		
		0.2.4201
		
		* Add "64bit" to producer info.
		- Fixed compress in 64bit.
		
		0.2.4012
		
		* Add DBReportPDFFont.LoadFontInfo
		
		0.2.2817
		
		- Fixed console issues.
		
		0.2.1614
		
		- Fixed ReadShort, ReadLong; Deprecated on Xojo 2015r2.
		
		0.2.1515
		
		* Add AddFontFolder.
		- Fixed some messages on Adobe reader.
		- Fixed fonts true type on windows objs.
		
		0.2.1510
		
		* Add DrawTextAreaAsImage.
		- Fixed some DrawTextArea issues.
		
		0.2.1504
		
		* Add GetCurrentBaseLine.
		- Fixed some DrawTextArea issues.
		
		0.2.1427
		
		- Fixed EURO and other characters.
		- Fixed multiline text problem.
		
		0.2.1404
		
		* Add support for image resolutions
		
		0.2.0204
		
		* Initial release
		
		TrueType: https://developer.apple.com/fonts/TTRefMan/index.html
		OpenType: http://www.microsoft.com/typography/otspec/default.htm
	#tag EndNote


	#tag Property, Flags = &h0
		Author As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Bold As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private CacheFontDescriptor As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private CacheFontFiles As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private CacheFontWidths As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		Compression As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared CR As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Creator As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Shared EmbeddedFonts As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		ForeColor As Color = &c00000000
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mHeight
			End Get
		#tag EndGetter
		Height As Double
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		Italic As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Keywords As String
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mLandscape
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If value Then
			    mPageWidth= mPageSizeOriginal.Y
			    mPageHeight= mPageSizeOriginal.X
			  Else
			    mPageWidth= mPageSizeOriginal.X
			    mPageHeight= mPageSizeOriginal.Y
			  End
			  ObjectPageCurrent.MediaBox.Width= mPageWidth
			  ObjectPageCurrent.MediaBox.Height= mPageHeight
			  
			  mLandscape = value
			End Set
		#tag EndSetter
		Landscape As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mCurrentBaseLine As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mHeight As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLandscape As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPageHeight As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPageSizeOriginal As REALbasic.Point
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPageWidth As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTextAscent As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTextHeight As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mWidth As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		ObjectCatalog As DBReportPDFCatalog
	#tag EndProperty

	#tag Property, Flags = &h21
		Private ObjectInfo As DBReportPDFObject
	#tag EndProperty

	#tag Property, Flags = &h21
		Private ObjectPageCurrent As DBReportPDFPageLeaf
	#tag EndProperty

	#tag Property, Flags = &h0
		Objects() As DBReportPDFObject
	#tag EndProperty

	#tag Property, Flags = &h0
		PenHeight As Double = 1
	#tag EndProperty

	#tag Property, Flags = &h0
		PenWidth As Double = 1
	#tag EndProperty

	#tag Property, Flags = &h0
		Subject As String
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mTextAscent
			End Get
		#tag EndGetter
		TextAscent As Double
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		TextFont As String = "Helvetica"
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mTextHeight
			End Get
		#tag EndGetter
		TextHeight As Double
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		TextSize As Double = 12
	#tag EndProperty

	#tag Property, Flags = &h0
		Title As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Underline As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		VersionPDF As String = "1.4"
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mWidth
			End Get
		#tag EndGetter
		Width As Double
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private XrefLocation As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Shared zlibLastErrorCode As Integer
	#tag EndProperty


	#tag Constant, Name = kPageHeight, Type = Double, Dynamic = False, Default = \"792", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kPageWidth, Type = Double, Dynamic = False, Default = \"612", Scope = Private
	#tag EndConstant

	#tag Constant, Name = Version, Type = String, Dynamic = False, Default = \"0.2.4201", Scope = Public
	#tag EndConstant

	#tag Constant, Name = Z_BUF_ERROR, Type = Double, Dynamic = False, Default = \"-5", Scope = Private
	#tag EndConstant

	#tag Constant, Name = Z_DATA_ERROR, Type = Double, Dynamic = False, Default = \"-3", Scope = Private
	#tag EndConstant

	#tag Constant, Name = Z_ERRNO, Type = Double, Dynamic = False, Default = \"-1", Scope = Private
	#tag EndConstant

	#tag Constant, Name = Z_MEM_ERROR, Type = Double, Dynamic = False, Default = \"-4", Scope = Private
	#tag EndConstant

	#tag Constant, Name = Z_OK, Type = Double, Dynamic = False, Default = \"0", Scope = Private
	#tag EndConstant

	#tag Constant, Name = Z_STREAM_ERROR, Type = Double, Dynamic = False, Default = \"-2", Scope = Private
	#tag EndConstant

	#tag Constant, Name = Z_VERSION_ERROR, Type = Double, Dynamic = False, Default = \"-6", Scope = Private
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Author"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Bold"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Compression"
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Creator"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ForeColor"
			Group="Behavior"
			InitialValue="&c000000"
			Type="Color"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Height"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Italic"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Keywords"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Landscape"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="PenHeight"
			Group="Behavior"
			InitialValue="1"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="PenWidth"
			Group="Behavior"
			InitialValue="1"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Subject"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TextAscent"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TextFont"
			Group="Behavior"
			InitialValue="Helvetica"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TextHeight"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TextSize"
			Group="Behavior"
			InitialValue="12"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Title"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Underline"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="VersionPDF"
			Group="Behavior"
			InitialValue="1.4"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Width"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
