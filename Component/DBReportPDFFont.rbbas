#tag Class
Protected Class DBReportPDFFont
Inherits DBReportPDFObject
	#tag Method, Flags = &h21
		Private Shared Function ChkFontName(fontName As String) As String
		  Dim s As String= fontName.ReplaceAll("@", "")
		  
		  Return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function ChkFontNameKey(fontName As String, isBold As Boolean, isItalic As Boolean) As String
		  Dim s As String= fontName
		  
		  If isBold And isItalic Then
		    If s.InStr("Bold")= 0 And s.InStr("Italic")= 0 Then
		      s= s+ ",BoldItalic"
		    ElseIf s.InStr("Bold")> 0 And s.InStr("Italic")= 0 Then
		      s= s.ReplaceAll("Bold", "")
		      If s.Right(1)= "-" Then s= s.ReplaceAll("-", "")
		      s= s+ ",BoldItalic"
		    ElseIf s.InStr("Bold")= 0 And s.InStr("Italic")> 0 Then
		      s= s.ReplaceAll("Italic", "")
		      If s.Right(1)= "-" Then s= s.ReplaceAll("-", "")
		      s= s+ ",BoldItalic"
		    End If
		  ElseIf isBold Then
		    If s.InStr("Bold")= 0 Then s= s+ ",Bold"
		  ElseIf isItalic Then
		    If s.InStr("Italic")= 0 Then s= s+ ",Italic"
		  Else
		    s= s.ReplaceAll("Bold", "")
		    s= s.ReplaceAll("Italic", "")
		    If s.Right(1)= "-" Then s= s.ReplaceAll("-", "")
		  End If
		  
		  Return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor(root As DBReportPDF, pdfReferenceName As String, fontName As String, bold As Boolean, italic As Boolean)
		  FileRoot= root
		  root.Objects.Append Me
		  
		  Type="Font"
		  Me.Name= pdfReferenceName
		  Me.BaseFont= fontName
		  Me.Bold= bold
		  Me.Italic= italic
		  
		  Select Case fontName
		  Case "Times"
		    IsInStandard14= True
		    SubType= "Type1"
		    If bold And Italic Then
		      BaseFont= "Times-BoldItalic"
		    ElseIf bold Then
		      BaseFont= "Times-Bold"
		    ElseIf italic Then
		      BaseFont= "Times-Italic"
		    Else
		      BaseFont= "Times-Roman"
		    End
		  Case "Helvetica", "System"
		    IsInStandard14= True
		    SubType= "Type1"
		    If bold And italic then
		      baseFont= "Helvetica-BoldOblique"
		    ElseIf bold Then
		      baseFont= "Helvetica-Bold"
		    ElseIf italic Then
		      baseFont= "Helvetica-Oblique"
		    Else
		      baseFont= "Helvetica"
		    End
		  Case "Courier"
		    isInStandard14=true
		    subType="Type1"
		    if bold and italic then
		      baseFont="Courier-BoldOblique"
		    elseif bold then
		      baseFont="Courier-Bold"
		    elseif italic then
		      baseFont="Courier-Oblique"
		    else
		      baseFont="Courier"
		    end
		  Case "Symbol"
		    isInStandard14=true
		    subType="Type1"
		    baseFont="Symbol"
		  Case "Zapf Dingbats"
		    isInStandard14=true
		    subType="Type1"
		    baseFont="ZapfDingbats"
		  Case Else
		    IsInStandard14= False
		    SubType= "TrueType"
		    
		    #if TargetWin32
		      If True Then // loadFont
		        If Not FontInfoLoaded Then LoadFontInfoWin
		        SetFontInfo BaseFont, Bold, Italic
		      Else
		        BaseFont= GetCacheKey(BaseFont, bold, italic)
		      End
		    #else
		      BaseFont= GetCacheKey(BaseFont, bold, italic)
		    #endif
		  End Select
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function GetCacheKey(fontName As String, isBold As Boolean, isItalic As Boolean) As String
		  If isBold And isItalic Then
		    fontName= fontName+ ",BoldItalic"
		  ElseIf isBold Then
		    fontName= fontName+ ",Bold"
		  ElseIf isItalic Then
		    fontName= fontName+ ",Italic"
		  Else
		    fontName= fontName
		  End
		  
		  Return ReplaceAll(fontName, " ", "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetData() As String
		  Dim s As String
		  
		  If IsInStandard14 Then
		    s= s+ "<< /Type /"+ Type+ " /Subtype /"+ SubType+ " /BaseFont /"+ BaseFont+ " /Encoding /WinAnsiEncoding >> "
		  Else
		    If  mFontFound Then
		      s= s+ "<< /Type /"+ Type+ " /Subtype /"+ SubType+ " /BaseFont /"+ BaseFont
		      s= s+ " /FirstChar "+ Str(FirstChar)+ " /LastChar "+ Str(LastChar)+ " /Widths "+ FontWidths.IndirectReference
		      s= s+ " /FontDescriptor "+ FontDescriptor.IndirectReference+ " /Encoding /WinAnsiEncoding >> "
		    Else
		      s= s+ "<< /Type /"+ Type+ " /Subtype /"+ SubType+ " /BaseFont /"+ BaseFont+ " /Encoding /WinAnsiEncoding >> "
		    End
		  End
		  
		  Return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function GetDifference(s1 As String, s2 As String) As Integer
		  Dim str1 As String= ConvertEncoding(s1, Encodings.UTF8)
		  Dim str2 As String= ConvertEncoding(s2, Encodings.UTF8)
		  
		  Dim n As Integer= str2.Len
		  Dim c As Integer
		  
		  For i As Integer= 1 To n
		    Dim ch As String= str1.Mid(i, 1)
		    If str2.InStr(ch)> 0 Then c= c+ 1
		  Next
		  
		  Return n- c
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub LoadFontInfoWin()
		  DBReportPDF.AddFontFolder SpecialFolder.Fonts
		  
		  For i As Integer= 0 To FontFolders.Ubound
		    Dim fFonts As FolderItem= FontFolders(i)
		    Dim n As Integer= fFonts.Count
		    
		    For j As Integer= 1 To n
		      Dim f As FolderItem= fFonts.Item(j)
		      If f<> Nil Then
		        If InStr(f.Name.Lowercase, ".ttf")> 0 Or InStr(f.Name.Lowercase, ".otf")> 0 Then
		          LoadFontInfoWinTTF f
		        ElseIf InStr(f.Name.Lowercase, ".ttc")> 0 Then
		          LoadFontInfoWinTTC f
		        End
		      End
		    Next
		  Next
		  
		  FontInfoLoaded= True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub LoadFontInfoWinTTC(f As FolderItem)
		  #pragma BackgroundTasks false // to speed up
		  
		  Dim ReadStream As BinaryStream= BinaryStream.Open(f, False)
		  
		  Dim tag As String= ReadStream.Read(4, Encodings.ASCII)
		  
		  If tag<> "ttcf" Then Return
		  
		  ReadStream.Position= ReadStream.Position+ 8
		  
		  Dim numTables As Integer= ReadStream.ReadUInt32
		  
		  Dim offsets() As Int64
		  For i As Integer= 1 To numTables
		    Dim offset As Int64= ReadStream.ReadUInt32
		    offsets.Append offset
		  Next
		  
		  For i As Integer= 0 To offsets.Ubound
		    LoadFontInfoWinTTF f, offsets(i), ReadStream
		  Next
		  
		  ReadStream.Close
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub LoadFontInfoWinTTF(f As FolderItem, offsetFile As Int64 = 0, Optional streamFile As BinaryStream)
		  #pragma BackgroundTasks false // to speed up
		  
		  #if not DebugBuild then // to speed up
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  'If InStr(f.Name.Lowercase, "Cambria")> 0 Then
		  'Dim xxx As Integer
		  'End
		  
		  Dim ReadStream As BinaryStream
		  If offsetFile= 0 Then ReadStream= BinaryStream.Open(f, False) Else ReadStream= streamFile
		  
		  // reads the Offset Table:
		  ReadStream.Position= offsetFile+ 4
		  Dim NumberOfTables As Integer= ReadStream.ReadInt16
		  
		  If NumberOfTables< 7 Then Return
		  
		  // reads a Directory Table:
		  ReadStream.Position= ReadStream.Position+ 6
		  Dim directoryTables As New Dictionary
		  Dim dtTemp As FontDirectoryTable
		  
		  ReadStream.Position= offsetFile+ 12
		  For i As Integer= 1 To NumberOfTables
		    dtTemp.Tag= ReadStream.Read(4, Encodings.ASCII)
		    dtTemp.Checksum= ReadStream.ReadInt32
		    dtTemp.Offset= ReadStream.ReadInt32
		    dtTemp.Length= ReadStream.ReadInt32
		    directoryTables.Value(dtTemp.Tag)= dtTemp
		  Next
		  
		  // reads the Names Table:
		  Dim FamilyName, FullName, FontName As String
		  If directoryTables.HasKey("name") Then
		    dtTemp= directoryTables.Value("name")
		    ReadStream.Position= dtTemp.Offset+ 2
		    
		    Dim platformID, platformEncodingID, languageID, nameID, length, offset, currentStreamPosition, i As Integer
		    Dim founded As Boolean
		    
		    Dim numTablesName As Integer= ReadStream.ReadInt16
		    Dim startOffset As Integer= ReadStream.ReadInt16
		    
		    While i< numTablesName And Not founded
		      platformID= ReadStream.ReadInt16
		      platformEncodingID= ReadStream.ReadInt16
		      languageID= ReadStream.ReadInt16
		      nameID= ReadStream.ReadInt16
		      length= ReadStream.ReadInt16
		      offset= ReadStream.ReadInt16
		      currentStreamPosition= ReadStream.Position
		      ReadStream.Position= dtTemp.Offset+ startOffset+ offset
		      Select Case nameID
		      Case 1
		        If platformID= 0 Or platformID= 3 Or platformID= 2 And platformEncodingID= 1 Then
		          FamilyName= ConvertEncoding(ReadStream.Read(length, Encodings.UTF16BE), Encodings.ASCII)
		        Else
		          FamilyName= ReadStream.Read(length, Encodings.ASCII)
		        End
		      Case 4
		        If platformID= 0 Or platformID= 3 Or platformID= 2 And platformEncodingID= 1 Then
		          FullName= ConvertEncoding(ReadStream.Read(length, Encodings.UTF16BE), Encodings.ASCII)
		        Else
		          FullName= ReadStream.Read(length, Encodings.ASCII)
		        End
		      Case 6
		        If platformID= 0 Or platformID= 3 Or platformID= 2 And platformEncodingID= 1 Then
		          FontName= ConvertEncoding(ReadStream.Read(length, Encodings.UTF16BE), Encodings.ASCII)
		        Else
		          FontName= ReadStream.Read(length, Encodings.ASCII)
		        End
		      End Select
		      If FamilyName<> "" And FullName<> "" And FontName<> "" Then
		        founded= True
		      Else
		        ReadStream.Position= currentStreamPosition
		        i= i+ 1
		      End
		    Wend
		  Else
		    Return
		  End
		  
		  // reads the FontHeader Table:
		  Dim headTable As FontHeaderTable
		  If directoryTables.HasKey("head") Then
		    dtTemp= directoryTables.Value("head")
		    ReadStream.Position= dtTemp.Offset+ 16
		    headTable.flags= ReadStream.ReadUInt16
		    headTable.unitsPerEm= ReadStream.ReadUInt16
		    ReadStream.Position= ReadStream.Position+ 16
		    headTable.xMin= ReadStream.ReadInt16
		    headTable.yMin= ReadStream.ReadInt16
		    headTable.xMax= ReadStream.ReadInt16
		    headTable.yMax= ReadStream.ReadInt16
		    headTable.macStyle= ReadStream.ReadUInt16
		  Else
		    Return
		  End
		  
		  Dim isBold, isItalic As Boolean
		  Dim sMacStyle As String= Bin(headTable.macStyle)
		  If FullName.InStr("Bold")> 0 Or Mid(sMacStyle, 1, 1)= "1" Then isBold= True
		  If FullName.InStr("Italic")> 0 Or Mid(sMacStyle, 2, 1)= "1" Then isItalic= True
		  
		  // chk if found on array
		  For i As Integer= 0 To CacheFontInfoDescriptor.Ubound
		    If CacheFontInfoDescriptor(i).FontName= FontName And CacheFontInfoDescriptor(i).isBold= isBold And _
		      CacheFontInfoDescriptor(i).isItalic= isItalic Then
		      Return
		    End
		  Next
		  
		  // reads the HorizontalHeader Table
		  Dim hheaTable As FontHorizontalHeaderTable
		  If directoryTables.HasKey("hhea") Then
		    dtTemp= directoryTables.Value("hhea")
		    ReadStream.Position= dtTemp.Offset+ 4
		    hheaTable.Ascender= ReadStream.ReadInt16
		    hheaTable.Descender=ReadStream.ReadInt16
		    hheaTable.LineGap= ReadStream.ReadInt16
		    hheaTable.advanceWidthMax= ReadStream.ReadUInt16
		    hheaTable.minLeftSideBearing= ReadStream.ReadInt16
		    hheaTable.minRightSideBearing= ReadStream.ReadInt16
		    hheaTable.xMaxExtent= ReadStream.ReadInt16
		    hheaTable.caretSlopeRise= ReadStream.ReadInt16
		    hheaTable.caretSlopeRun= ReadStream.ReadInt16
		    ReadStream.Position= ReadStream.Position+ 12
		    hheaTable.numberOfHMetrics= ReadStream.ReadUInt16
		  Else
		    Return
		  End
		  
		  // reads the OS Table:
		  Dim isSerif, isScript, isSymbolic As Boolean
		  Dim sTypoAscender, sTypoDescender, sCapHeight, sxHeight As Integer
		  If directoryTables.HasKey("os/2") Or directoryTables.HasKey("OS/2") Then
		    Dim key As String
		    If directoryTables.HasKey("os/2") Then key= "os/2" Else key= "OS/2"
		    dtTemp= directoryTables.Value(key)
		    ReadStream.Position= dtTemp.Offset
		    Dim osVersion As Integer= ReadStream.ReadInt16
		    If osVersion= 0 Then
		      ReadStream.Position= ReadStream.Position+ (2* 13)
		    Else
		      ReadStream.Position= ReadStream.Position+ (2* 14)
		    End
		    
		    Dim sFamilyClass As Integer=  ReadStream.ReadInt8
		    If sFamilyClass> 0 And sFamilyClass<= 7 Then isSerif= True
		    If sFamilyClass= 10 Then isScript= True
		    If sFamilyClass= 12 Then isSymbolic= True
		    
		    ReadStream.Position= ReadStream.Position+ 10+ 16+ 4+ 6+ 1
		    sTypoAscender= ReadStream.ReadInt16
		    sTypoDescender= ReadStream.ReadInt16
		    
		    ReadStream.Position= ReadStream.Position+ 14
		    If osVersion> 1 Then
		      sxHeight= ReadStream.ReadInt16
		      sCapHeight= ReadStream.ReadInt16
		    Else
		      sCapHeight= sTypoAscender
		    End
		  Else
		    Return
		  End
		  
		  // reads the PostScript Table:
		  Dim postTable As FontPostScriptTable
		  If directoryTables.HasKey("post") Then
		    dtTemp= directoryTables.Value("post")
		    ReadStream.Position= dtTemp.Offset+ 4
		    Dim mantissa As Integer= ReadStream.ReadInt16
		    Dim fraction As Integer= ReadStream.ReadUInt16
		    postTable.ItalicAngle= mantissa+ fraction / 16384.0
		    postTable.UnderlinePosition= ReadStream.ReadInt16
		    postTable.UnderlineThickness= ReadStream.ReadInt16
		    postTable.IsFixedPitch= (ReadStream.ReadInt16<> 0)
		  Else
		    Return
		  End
		  
		  // reads the Glyph's Widths:
		  Dim GlyphWidths() As Integer
		  If directoryTables.HasKey("hmtx") Then
		    dtTemp= directoryTables.Value("hmtx")
		    ReadStream.Position= dtTemp.Offset
		    For i As Integer= 0 To hheaTable.numberOfHMetrics- 1
		      GlyphWidths.Append (ReadStream.ReadUInt16* 1000)/ headTable.unitsPerEm
		      ReadStream.Position= ReadStream.Position+ 2
		    Next
		  Else
		    Return
		  End
		  
		  // reads the CMAP
		  Dim CharacterWidths() As Integer
		  If directoryTables.HasKey("cmap") Then
		    dtTemp= directoryTables.Value("cmap")
		    ReadStream.Position= dtTemp.Offset+ 2
		    Dim tblNumber As Integer= ReadStream.ReadUInt16
		    Dim platformID, encodingID, offset, format As Integer
		    Dim cmaps() As DBReportPDFFontCMAP
		    For i As Integer= 0 To tblNumber- 1
		      platformID= ReadStream.ReadUInt16
		      encodingID= ReadStream.ReadUInt16
		      offset= ReadStream.ReadUInt32
		      cmaps.Append New DBReportPDFFontCMAP(platformID, encodingID, offset)
		    Next
		    
		    Dim returnCMAP As New Dictionary
		    
		    For i As Integer= 0 To cmaps.Ubound
		      ReadStream.Position= dtTemp.Offset+ cmaps(i).Offset
		      format= ReadStream.ReadUInt16
		      
		      If cmaps(i).PlatformID= 3 And cmaps(i).EncodingID= 1 And format= 4 Then // MS-Unicode-CMAP is used for priority
		        
		        Dim table_lenght As Integer= ReadStream.ReadUInt16
		        ReadStream.Position= ReadStream.Position+ 2
		        Dim seg As Integer= ReadStream.ReadUInt16/ 2
		        
		        ReadStream.Position= ReadStream.Position+ 6
		        Dim end0() As Integer
		        ReDim end0(seg)
		        For ii As Integer= 0 To seg- 1
		          end0(ii)= ReadStream.ReadUInt16
		        Next
		        
		        ReadStream.Position= ReadStream.Position+ 2
		        Dim start() As Integer
		        ReDim start(seg)
		        For ii As Integer= 0 To seg- 1
		          start(ii)= ReadStream.ReadUInt16
		        Next
		        
		        Dim delta() As Integer
		        ReDim delta(seg)
		        For ii As Integer= 0 To seg- 1
		          delta(ii)= ReadStream.ReadUInt16
		        Next
		        
		        Dim ro() As Integer
		        ReDim  ro(seg)
		        For ii As Integer= 0 To seg- 1
		          ro(ii)= ReadStream.ReadUInt16
		        Next
		        
		        Dim glyphId() As Integer
		        Dim glyphIdUbound As Integer= table_lenght/ 2- 8- seg* 4
		        ReDim  glyphId(glyphIdUbound)
		        For ii As Integer= 0 To glyphIdUbound
		          glyphId(ii)= ReadStream.ReadUInt16
		        Next
		        
		        Dim glyph, idx As Integer
		        
		        For ii As Integer= 0 To seg- 1
		          For jj As Integer= start(ii) To end0(ii)
		            If jj= &hFFFF Then Exit For jj
		            If ro(ii)= 0 Then
		              glyph= (jj + delta(ii)) And &hFFFF
		            Else
		              idx= ii+ ro(ii)/ 2- seg+ jj- start(ii)
		              glyph = (glyphId(idx)+ delta(ii)) And &hFFFF
		            End
		            Dim glyphInfo(1) As Integer
		            glyphInfo(0)= glyph
		            If glyph<= GlyphWidths.Ubound- 1 Then glyphInfo(1)= GlyphWidths(glyphInfo(0)) Else glyphInfo(1)= 0
		            returnCMAP.Value(jj)= glyphInfo
		          Next
		        Next
		        
		        cmaps(i).Mapping= returnCMAP
		      End If
		    Next
		    
		    If returnCMAP.Count= 0 Then // try other
		      For i As Integer= 0 To cmaps.Ubound
		        ReadStream.Position= dtTemp.Offset+ cmaps(i).Offset
		        format= ReadStream.ReadUInt16
		        
		        If cmaps(i).PlatformID= 1 And cmaps(i).EncodingID= 0 And format= 1 Then // Byte-Encoding-CMAP will be used
		          ReadStream.Position= ReadStream.Position+ 4
		          For j As Integer= 0 To 254
		            Dim glyphInfo(1) As Integer
		            glyphInfo(0)= ReadStream.ReadUInt8
		            glyphInfo(1)= GlyphWidths(glyphInfo(0))
		            returnCMAP.Value(j)= glyphInfo
		          Next
		          
		          cmaps(i).Mapping= returnCMAP
		        ElseIf cmaps(i).PlatformID= 1 And format= 6 Then
		          ReadStream.Position= ReadStream.Position+ 4
		          Dim start As Integer= ReadStream.ReadUInt16
		          Dim count As Integer= ReadStream.ReadUInt16
		          For j As Integer= 0 To count-1
		            Dim glyphInfo(1) As Integer
		            glyphInfo(0)= ReadStream.ReadUInt8
		            glyphInfo(1)= GlyphWidths(glyphInfo(0))
		            returnCMAP.Value(j+ start)= glyphInfo
		          Next
		          
		          cmaps(i).Mapping= returnCMAP
		        End If
		      Next
		    End If
		    
		    If returnCMAP.Count> 0 Then // here!!
		      For i As Integer= 0 To 65535
		        If returnCMAP.HasKey(i) Then
		          Dim myMetric() As Integer= returnCMAP.Value(i)
		          CharacterWidths.Append myMetric(1)
		          If CharacterWidths.Ubound+ 1= LastChar- FirstChar+ 1 Then Exit For i
		        ElseIf i< 32 Then
		          CharacterWidths.Append GlyphWidths(0)
		        ElseIf CharacterWidths.Ubound+ 1<= LastChar- FirstChar+ 1 Then
		          CharacterWidths.Append 0
		        End If
		      Next
		    End
		  Else
		    Return
		  End
		  
		  // put in cache
		  Dim cacheD As New DBReportPDFFontDescriptor
		  cacheD.FontName= FontName
		  cacheD.FontFamily= FamilyName
		  cacheD.FontNameOS= FullName
		  cacheD.isBold= isBold
		  cacheD.isForceBold= isBold
		  cacheD.isItalic= isItalic
		  cacheD.FontBBox= New DBReportPDFRect( (headTable.xMin* 1000/ headTable.unitsPerEm), _
		  (headTable.yMin* 1000/ headTable.unitsPerEm), (headTable.xMax* 1000/ headTable.unitsPerEm), _
		  (headTable.yMax* 1000/ headTable.unitsPerEm))
		  cacheD.CapHeight= Round(sCapHeight* 1000/ headTable.unitsPerEm)
		  cacheD.Ascent= Round(sTypoAscender* 1000/ headTable.unitsPerEm)
		  cacheD.Descent= Round(sTypoDescender* 1000/ headTable.unitsPerEm)
		  cacheD.isFixedPitch= postTable.IsFixedPitch
		  cacheD.isScript= isScript
		  cacheD.isSerif= isSerif
		  cacheD.isSymbolic= isSymbolic
		  cacheD.xHeight= Round(sxHeight* 1000/ headTable.unitsPerEm)
		  cacheD.CapHeight=  Round(sCapHeight* 1000/ headTable.unitsPerEm)
		  CacheFontInfoDescriptor.Append cacheD
		  
		  If DBReportPDF.EmbeddedFonts Then
		    CacheFontInfoFontFile.Append New DBReportPDFFontFile(Nil, f) //font file
		  End
		  
		  Dim cacheFW As New DBReportPDFFontWidths
		  If CharacterWidths.Ubound> -1 Then
		    For i As Integer= 0 To CharacterWidths.Ubound
		      cacheFW.Widths.Append CharacterWidths(i)
		    Next
		  End
		  CacheFontInfoWidths.Append cacheFW
		  
		  If offsetFile= 0 Then ReadStream.Close
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SetFontInfo(baseFont As String, isBold As Boolean, isItalic As Boolean)
		  Dim nFonts As Integer= CacheFontInfoDescriptor.Ubound
		  
		  mFontFound= False
		  
		  For i As Integer= 0 To nFonts
		    Dim cacheD As DBReportPDFFontDescriptor= CacheFontInfoDescriptor(i)
		    
		    If cacheD.FontFamily.InStr(ChkFontName(baseFont))> 0 Then
		      If isBold And isItalic Then
		        If cacheD.isBold And cacheD.isItalic Then mFontFound= True
		      ElseIf isBold Then
		        If cacheD.isBold Then mFontFound= True
		      ElseIf isItalic Then
		        If cacheD.isItalic Then mFontFound= True
		      Else
		        If Not cacheD.isBold And Not cacheD.isItalic Then mFontFound= True
		      End
		      
		      If mFontFound Then
		        FontDescriptor= New DBReportPDFFontDescriptor(FileRoot)
		        FontDescriptor.BaseFont= ChkFontNameKey(cacheD.FontName, isBold, isItalic)
		        FontDescriptor.FontName= cacheD.FontName
		        FontDescriptor.FontFamily= cacheD.FontFamily
		        FontDescriptor.FontNameOS= cacheD.FontNameOS
		        FontDescriptor.isBold= cacheD.isBold
		        FontDescriptor.isItalic= cacheD.isItalic
		        FontDescriptor.FontBBox= New DBReportPDFRect(cacheD.FontBBox.Left, cacheD.FontBBox.Top, _
		        cacheD.FontBBox.Width, cacheD.FontBBox.Height)
		        FontDescriptor.CapHeight= cacheD.CapHeight
		        FontDescriptor.Ascent= cacheD.Ascent
		        FontDescriptor.Descent= cacheD.Descent
		        FontDescriptor.isFixedPitch= cacheD.isFixedPitch
		        FontDescriptor.isForceBold= cacheD.isForceBold
		        FontDescriptor.isScript= cacheD.isScript
		        FontDescriptor.isSerif= cacheD.isSerif
		        FontDescriptor.isSymbolic= cacheD.isSymbolic
		        FontDescriptor.xHeight= cacheD.xHeight
		        FontDescriptor.CapHeight= cacheD.CapHeight
		        
		        If DBReportPDF.EmbeddedFonts Then
		          Dim cacheFF As DBReportPDFFontFile= CacheFontInfoFontFile(i)
		          If FileRoot.CacheGetFontFileHasKey(cacheFF.FileFont.Name) Then
		            FontDescriptor.FontFile= FileRoot.CacheGetFontFile(cacheFF.FileFont.Name)
		          Else
		            FontDescriptor.FontFile= New DBReportPDFFontFile(FileRoot, cacheFF.FileFont)
		            FileRoot.CacheSetFontFile cacheFF.FileFont.Name, FontDescriptor.FontFile
		          End
		        End If
		        
		        Dim cacheFW As DBReportPDFFontWidths= CacheFontInfoWidths(i)
		        FontWidths= New DBReportPDFFontWidths(FileRoot)
		        FontWidths.Widths= cacheFW.Widths
		        
		        Dim key As String= GetCacheKey(baseFont, isBold, isItalic)
		        FileRoot.CacheSetFontDescriptor key, FontDescriptor
		        FileRoot.CacheSetFontWidths key, FontWidths
		        
		        Me.BaseFont= FontDescriptor.BaseFont //change orignal name to name of file
		        Exit For
		      End
		    End
		  Next
		  
		  If Not mFontFound Then // search for same name
		    Dim cacheD As DBReportPDFFontDescriptor
		    Dim ii As Integer
		    
		    For i As Integer= 0 To nFonts- 1 // search for name without bold, italic
		      cacheD= CacheFontInfoDescriptor(i)
		      
		      If cacheD.FontFamily.InStr(ChkFontName(baseFont))> 0 Then
		        ii= i
		        mFontFound= True
		        Exit for i
		      End
		    Next
		    
		    If Not mFontFound Then // search for name like
		      For i As Integer= 0 To nFonts- 1
		        cacheD= CacheFontInfoDescriptor(i)
		        
		        If GetDifference(ChkFontName(baseFont), cacheD.FontFamily)< 3 Then
		          ii= i
		          mFontFound= True
		          Exit for i
		        End
		      Next
		    End If
		    
		    If mFontFound Then
		      FontDescriptor= New DBReportPDFFontDescriptor(FileRoot)
		      FontDescriptor.BaseFont= ChkFontNameKey(cacheD.FontName, isBold, isItalic)
		      FontDescriptor.FontName= cacheD.FontName
		      FontDescriptor.FontFamily= cacheD.FontFamily
		      FontDescriptor.FontNameOS= cacheD.FontNameOS
		      FontDescriptor.isBold= isBold // cacheD.isBold
		      FontDescriptor.isItalic= isItalic // cacheD.isItalic
		      FontDescriptor.FontBBox= New DBReportPDFRect(cacheD.FontBBox.Left, cacheD.FontBBox.Top, _
		      cacheD.FontBBox.Width, cacheD.FontBBox.Height)
		      FontDescriptor.CapHeight= cacheD.CapHeight
		      FontDescriptor.Ascent= cacheD.Ascent
		      FontDescriptor.Descent= cacheD.Descent
		      FontDescriptor.isFixedPitch= cacheD.isFixedPitch
		      FontDescriptor.isForceBold= cacheD.isForceBold
		      FontDescriptor.isScript= cacheD.isScript
		      FontDescriptor.isSerif= cacheD.isSerif
		      FontDescriptor.isSymbolic= cacheD.isSymbolic
		      FontDescriptor.xHeight= cacheD.xHeight
		      FontDescriptor.CapHeight= cacheD.CapHeight
		      
		      If DBReportPDF.EmbeddedFonts Then
		        Dim cacheFF As DBReportPDFFontFile= CacheFontInfoFontFile(ii)
		        If FileRoot.CacheGetFontFileHasKey(cacheFF.FileFont.Name) Then
		          FontDescriptor.FontFile= FileRoot.CacheGetFontFile(cacheFF.FileFont.Name)
		        Else
		          FontDescriptor.FontFile= New DBReportPDFFontFile(FileRoot, cacheFF.FileFont)
		          FileRoot.CacheSetFontFile cacheFF.FileFont.Name, FontDescriptor.FontFile
		        End
		      End If
		      
		      Dim cacheFW As DBReportPDFFontWidths= CacheFontInfoWidths(ii)
		      FontWidths= New DBReportPDFFontWidths(FileRoot)
		      FontWidths.Widths= cacheFW.Widths
		      
		      Dim key As String= GetCacheKey(baseFont, isBold, isItalic)
		      FileRoot.CacheSetFontDescriptor key, FontDescriptor
		      FileRoot.CacheSetFontWidths key, FontWidths
		      
		      Me.BaseFont= FontDescriptor.BaseFont //change orignal name to name of file
		    End If
		    
		  End
		  
		  If Not mFontFound Then Me.BaseFont= GetCacheKey(baseFont, isBold, isItalic)
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		BaseFont As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Bold As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared CacheFontInfoDescriptor() As DBReportPDFFontDescriptor
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared CacheFontInfoFontFile() As DBReportPDFFontFile
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared CacheFontInfoWidths() As DBReportPDFFontWidths
	#tag EndProperty

	#tag Property, Flags = &h21
		Private FileRoot As DBReportPDF
	#tag EndProperty

	#tag Property, Flags = &h0
		FirstChar As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0
		FontDescriptor As DBReportPDFFontDescriptor
	#tag EndProperty

	#tag Property, Flags = &h0
		Attributes( Hidden ) Shared FontFolders() As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared FontInfoLoaded As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		FontWidths As DBReportPDFFontWidths
	#tag EndProperty

	#tag Property, Flags = &h21
		Private IsInStandard14 As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Italic As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		LastChar As Integer = 255
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mFontFound As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Name As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private SubType As String
	#tag EndProperty


	#tag Structure, Name = FontDirectoryTable, Flags = &h21
		Tag As String*4
		  Checksum As Integer
		  Offset As Integer
		Length As Integer
	#tag EndStructure

	#tag Structure, Name = FontHeaderTable, Flags = &h21
		flags As Integer
		  unitsPerEm As Integer
		  xMin As Int16
		  yMin As Int16
		  xMax As Int16
		  yMax As Int16
		macStyle As Integer
	#tag EndStructure

	#tag Structure, Name = FontHorizontalHeaderTable, Flags = &h21
		Ascender As Int16
		  Descender As Int16
		  LineGap As Int16
		  advanceWidthMax As Integer
		  minLeftSideBearing As Int16
		  minRightSideBearing As Int16
		  xMaxExtent As Int16
		  caretSlopeRise As Int16
		  caretSlopeRun As Int16
		numberOfHMetrics As Integer
	#tag EndStructure

	#tag Structure, Name = FontPostScriptTable, Flags = &h21
		ItalicAngle As Double
		  UnderlinePosition As Integer
		  UnderlineThickness As Integer
		IsFixedPitch As Boolean
	#tag EndStructure


	#tag ViewBehavior
		#tag ViewProperty
			Name="BaseFont"
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
			Name="ByteOffset"
			Group="Behavior"
			Type="Integer"
			InheritedFrom="DBReportPDFObject"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FirstChar"
			Group="Behavior"
			InitialValue="32"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Generator"
			Group="Behavior"
			Type="Integer"
			InheritedFrom="DBReportPDFObject"
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
			Name="LastChar"
			Group="Behavior"
			InitialValue="255"
			Type="Integer"
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
			Name="Number"
			Group="Behavior"
			Type="Integer"
			InheritedFrom="DBReportPDFObject"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Type"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
			InheritedFrom="DBReportPDFObject"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
