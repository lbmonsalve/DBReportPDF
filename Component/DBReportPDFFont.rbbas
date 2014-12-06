#tag Class
Protected Class DBReportPDFFont
Inherits DBReportPDFObject
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
		      If DBReportPDF.EmbeddedFonts Then
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
		 Shared Function GetCacheKey(fontName As String, bold As Boolean, italic As Boolean) As String
		  If Bold And Italic Then
		    fontName= fontName+ ",BoldItalic"
		  ElseIf bold Then
		    fontName= fontName+ ",Bold"
		  ElseIf italic Then
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
		Private Sub LoadFontInfoWin()
		  Dim fFonts As FolderItem= SpecialFolder.Fonts
		  If fFonts= Nil Then Return
		  
		  mFontFound= False
		  Dim n As Integer= fFonts.Count
		  
		  For i As Integer= 1 To n
		    Dim f As FolderItem= fFonts.Item(i)
		    If f<> Nil Then
		      If InStr(f.Name.Lowercase, ".ttf")> 0 Then
		        LoadFontInfoWinTTF f
		      End
		    End
		  Next
		  
		  FontInfoLoaded= True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub LoadFontInfoWinTTF(f As FolderItem)
		  #pragma BackgroundTasks false // to speed up
		  
		  #if not DebugBuild then // to speed up
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  Dim ReadStream as BinaryStream = BinaryStream.Open(f, False)
		  
		  Dim NumberOfTables, SearchRange, EntrySelector, RangeShift As Integer
		  Dim FamilyName, FullName, FontName As String
		  Dim headTable As FontHeaderTable
		  Dim hheaTable As FontHorizontalHeaderTable
		  Dim sTypoAscender, sTypoDescender, sCapHeight As Integer
		  Dim postTable As FontPostScriptTable
		  Dim GlyphWidths() As Integer
		  Dim CharacterWidths() As Integer
		  
		  'reads the Offset Table:
		  ReadStream.Position= 4
		  NumberOfTables= ReadStream.ReadShort
		  SearchRange= ReadStream.ReadShort
		  EntrySelector= ReadStream.ReadShort
		  RangeShift= ReadStream.ReadShort
		  
		  'reads a Directory Table:
		  Dim directoryTables As New Dictionary
		  Dim dtTemp As FontDirectoryTable
		  
		  ReadStream.Position= 12
		  For i As Integer= 1 To NumberOfTables
		    dtTemp.Tag= ReadStream.Read(4, Encodings.ASCII)
		    dtTemp.Checksum= ReadStream.ReadLong
		    dtTemp.Offset= ReadStream.ReadLong
		    dtTemp.Length= ReadStream.ReadLong
		    directoryTables.Value(dtTemp.Tag)= dtTemp
		  Next
		  
		  'reads the Names Table:
		  If directoryTables.HasKey("name") Then
		    dtTemp= directoryTables.Value("name")
		    ReadStream.Position= dtTemp.Offset+ 2
		    
		    Dim platformID, platformEncodingID, languageID, nameID, length, offset, currentStreamPosition, i As Integer
		    Dim founded As Boolean
		    
		    Dim numTablesName As Integer= ReadStream.ReadShort
		    Dim startOffset As Integer= ReadStream.ReadShort
		    
		    While i< numTablesName And Not founded
		      platformID= ReadStream.ReadShort
		      platformEncodingID= ReadStream.ReadShort
		      languageID= ReadStream.ReadShort
		      nameID= ReadStream.ReadShort
		      length= ReadStream.ReadShort
		      offset= ReadStream.ReadShort
		      currentStreamPosition= ReadStream.Position
		      ReadStream.Position= dtTemp.Offset+ startOffset+ offset
		      Select Case nameID
		      Case 1
		        If platformID= 0 Or platformID= 3 Or platformID= 2 And platformEncodingID= 1 Then
		          FamilyName= ReadStream.Read(length, Encodings.UTF16BE)
		        Else
		          FamilyName= ReadStream.Read(length, Encodings.ASCII)
		        End
		      Case 4
		        If platformID= 0 Or platformID= 3 Or platformID= 2 And platformEncodingID= 1 Then
		          FullName= ReadStream.Read(length, Encodings.UTF16BE)
		        Else
		          FullName= ReadStream.Read(length, Encodings.ASCII)
		        End
		      Case 6
		        If platformID= 0 Or platformID= 3 Or platformID= 2 And platformEncodingID= 1 Then
		          FontName= ReadStream.Read(length, Encodings.UTF16BE)
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
		  End
		  
		  'reads the FontHeader Table:
		  If directoryTables.HasKey("head") Then
		    dtTemp= directoryTables.Value("head")
		    ReadStream.Position= dtTemp.Offset+ 16
		    headTable.flags= ReadStream.ReadUInt16
		    headTable.unitsPerEm= ReadStream.ReadUInt16
		    ReadStream.Position= ReadStream.Position+ 16
		    headTable.xMin= ReadStream.ReadShort
		    headTable.yMin= ReadStream.ReadShort
		    headTable.xMax= ReadStream.ReadShort
		    headTable.yMax= ReadStream.ReadShort
		    headTable.macStyle= ReadStream.ReadUInt16
		  End
		  
		  'reads the HorizontalHeader Table
		  If directoryTables.HasKey("hhea") Then
		    dtTemp= directoryTables.Value("hhea")
		    ReadStream.Position= dtTemp.Offset+ 4
		    hheaTable.Ascender= ReadStream.ReadShort
		    hheaTable.Descender=ReadStream.ReadShort
		    hheaTable.LineGap= ReadStream.ReadShort
		    hheaTable.advanceWidthMax= ReadStream.ReadUInt16
		    hheaTable.minLeftSideBearing= ReadStream.ReadShort
		    hheaTable.minRightSideBearing= ReadStream.ReadShort
		    hheaTable.xMaxExtent= ReadStream.ReadShort
		    hheaTable.caretSlopeRise= ReadStream.ReadShort
		    hheaTable.caretSlopeRun= ReadStream.ReadShort
		    ReadStream.Position= ReadStream.Position+ 12
		    hheaTable.numberOfHMetrics= ReadStream.ReadUInt16
		  End
		  
		  'reads the OS Table:
		  If directoryTables.HasKey("os/2") Or directoryTables.HasKey("OS/2") Then
		    Dim key As String
		    If directoryTables.HasKey("os/2") Then key= "os/2" Else key= "OS/2"
		    dtTemp= directoryTables.Value(key)
		    ReadStream.Position= dtTemp.Offset
		    Dim osVersion As Integer= ReadStream.ReadShort
		    If osVersion= 0 Then
		      ReadStream.Position= ReadStream.Position+ (2* 14)+ 10+ 16+ 4+ 6
		    Else
		      ReadStream.Position= ReadStream.Position+ (2* 15)+ 10+ 16+ 4+ 6
		    End
		    sTypoAscender= ReadStream.ReadShort
		    sTypoDescender= ReadStream.ReadShort
		    ReadStream.Position= ReadStream.Position+ 8
		    If osVersion> 0 Then
		      ReadStream.Position= ReadStream.Position+ 8
		    End
		    If osVersion> 1 Then
		      ReadStream.Position= ReadStream.Position+ 2
		      sCapHeight= ReadStream.ReadShort
		    Else
		      sCapHeight= sTypoAscender
		    End
		  End
		  
		  'reads the PostScript Table:
		  If directoryTables.HasKey("post") Then
		    dtTemp= directoryTables.Value("post")
		    ReadStream.Position= dtTemp.Offset+ 4
		    Dim mantissa As Int16= ReadStream.ReadShort
		    Dim fraction As Integer= ReadStream.ReadUInt16
		    postTable.ItalicAngle= mantissa+ fraction / 16384.0
		    postTable.UnderlinePosition= ReadStream.ReadShort
		    postTable.UnderlineThickness= ReadStream.ReadShort
		    postTable.IsFixedPitch= (ReadStream.ReadShort<> 0)
		  End
		  
		  'reads the Glyph's Widths:
		  If directoryTables.HasKey("hmtx") Then
		    dtTemp= directoryTables.Value("hmtx")
		    ReadStream.Position= dtTemp.Offset
		    For i As Integer= 0 To hheaTable.numberOfHMetrics- 1
		      GlyphWidths.Append (ReadStream.ReadUInt16* 1000)/ headTable.unitsPerEm
		      ReadStream.Position= ReadStream.Position+ 2
		    Next
		  End
		  
		  'reads the CMAP
		  If directoryTables.HasKey("cmap") Then
		    dtTemp= directoryTables.Value("cmap")
		    ReadStream.Position= dtTemp.Offset+ 2
		    Dim tblNumber As Integer= ReadStream.ReadUInt16
		    Dim platformID, encodingID, offset, format As Integer
		    Dim cmaps() As DBReportPDFFontCMAP
		    For i As Integer= 0 To tblNumber- 1
		      platformID= ReadStream.ReadUInt16
		      encodingID= ReadStream.ReadUInt16
		      offset= ReadStream.ReadUInt16
		      cmaps.Append New DBReportPDFFontCMAP(platformID, encodingID, offset)
		    Next
		    
		    For i As Integer= 0 To cmaps.Ubound
		      ReadStream.Position= dtTemp.Offset+ cmaps(i).Offset
		      format= ReadStream.ReadUInt16
		      Select Case cmaps(i).PlatformID
		      Case 1 //Apple
		        Select Case format
		        Case 0 //read the TTF Format 0
		          Dim returnTable As New Dictionary
		          Dim glyphInfo() As Integer
		          
		          ReadStream.Position= ReadStream.Position+ 4
		          For j As Integer= 0 To 254
		            Redim glyphInfo(1)
		            glyphInfo(0)= ReadStream.ReadUInt8
		            glyphInfo(1)= GlyphWidths(glyphInfo(0))
		            returnTable.Value(j)= glyphInfo
		          Next
		          cmaps(i).Mapping= returnTable
		        Case 4 //read the TTF Format 4
		          Dim returnTable As New Dictionary
		          Dim glyphInfo() As Integer
		          
		          Dim glyph, idx As Integer
		          Dim table_lenght As Integer= ReadStream.ReadUInt16
		          ReadStream.Position= ReadStream.Position+ 2
		          Dim seg As Integer= ReadStream.ReadUInt16/ 2
		          ReadStream.Position= ReadStream.Position+ 6
		          Dim end0() As Integer
		          ReDim end0(seg)
		          For kk As Integer= 0 To seg- 1
		            end0(kk)= ReadStream.ReadUInt16
		          Next
		          ReadStream.Position= ReadStream.Position+ 2
		          Dim start() As Integer
		          ReDim start(seg)
		          For kk As Integer= 0 To seg- 1
		            start(kk)= ReadStream.ReadUInt16
		          Next
		          Dim delta() As Integer
		          ReDim delta(seg)
		          For kk As Integer= 0 To seg- 1
		            delta(kk)= ReadStream.ReadUInt16
		          Next
		          Dim ro() As Integer
		          ReDim  ro(seg)
		          For kk As Integer= 0 To seg- 1
		            ro(kk)= ReadStream.ReadUInt16
		          Next
		          Dim glyphId() As Integer
		          ReDim  glyphId(table_lenght/ 2- 8- seg* 4)
		          For kk As Integer= 0 To glyphId.Ubound
		            glyphId(kk)= ReadStream.ReadUInt16
		          Next
		          For kk As Integer= 0 To seg- 1
		            For ll As Integer= start(kk) To end0(kk)
		              If ll<> &hFFFF Then
		                If ro(kk)= 0 Then
		                  glyph= (ll + delta(kk)) And &hFFFF
		                Else
		                  idx= kk+ ro(kk)/ 2- seg+ ll- start(kk)
		                  glyph = (glyphId(idx)+ delta(kk)) And &hFFFF
		                End
		                Redim glyphInfo(1)
		                glyphInfo(0)= glyph
		                glyphInfo(1)= GlyphWidths(glyphInfo(0))
		                returnTable.Value(ll)= glyphInfo
		              End
		            Next
		          Next
		          cmaps(i).Mapping= returnTable
		        Case 6 //read the TTF Format 6
		          Dim returnTable As New Dictionary
		          Dim glyphInfo() As Integer
		          ReadStream.Position= ReadStream.Position+ 4
		          Dim start As Integer= ReadStream.ReadUInt16
		          Dim count As Integer= ReadStream.ReadUInt16
		          For j As Integer= 0 To count-1
		            Redim glyphInfo(1)
		            glyphInfo(0)= ReadStream.ReadUInt8
		            glyphInfo(1)= GlyphWidths(glyphInfo(0))
		            returnTable.Value(j+ start)= glyphInfo
		          Next
		          cmaps(i).Mapping= returnTable
		        End Select
		      Case 3 //Microsoft
		        If format= 4 Then
		          Dim returnTable As New Dictionary
		          cmaps(i).Mapping= returnTable
		        End
		      End Select
		    Next
		    
		    Dim returnCMAP As DBReportPDFFontCMAP
		    Dim ii As Integer
		    
		    While (ii< cmaps.Ubound+ 1) And returnCMAP= Nil
		      If cmaps(ii).PlatformID= 3 And cmaps(ii).EncodingID= 1 Then
		        returnCMAP= cmaps(ii)
		      End
		      ii= ii+ 1
		    Wend
		    
		    ii= 0
		    While (ii< cmaps.Ubound+ 1) And returnCMAP= Nil
		      If cmaps(ii).PlatformID= 1 And cmaps(ii).EncodingID= 0 Then
		        returnCMAP= cmaps(ii)
		      End
		      ii= ii+ 1
		    Wend
		    
		    If returnCMAP<> Nil Then //aquí!!
		      Dim myDefinition As New Dictionary
		      For i As Integer= 0 To 65535
		        Dim myCMAP As Dictionary= returnCMAP.Mapping
		        If myCMAP.HasKey(i) Then
		          Dim myMetric() As Integer= myCMAP.Value(i)
		          myDefinition.Value(i)= myMetric
		        End
		      Next
		      
		      For i As Integer= 0 To myDefinition.Count- 1
		        Dim myMetric() As Integer= myDefinition.Value(myDefinition.Key(i))
		        CharacterWidths.Append myMetric(1)
		      Next
		      
		    End
		  End
		  
		  'put in cache
		  Dim cacheD As New DBReportPDFFontDescriptor
		  cacheD.FontName= FontName
		  cacheD.FontFamily= FamilyName
		  'cacheD.FontNameOS= BaseFont //same FontFamily
		  Dim sMacStyle As String= Bin(headTable.macStyle)
		  If FullName.InStr("Bold")> 0 Or Mid(sMacStyle, 1, 1)= "1" Then
		    cacheD.isBold= True
		  End
		  If FullName.InStr("Italic")> 0 Or Mid(sMacStyle, 2, 1)= "1" Then
		    cacheD.isItalic= True
		  End
		  cacheD.FontBBox= New DBReportPDFRect(Ceil(headTable.xMin* 1000/ headTable.unitsPerEm), _
		  Ceil(headTable.yMin* 1000/ headTable.unitsPerEm), Floor(headTable.xMax* 1000/ headTable.unitsPerEm), _
		  Floor(headTable.yMax* 1000/ headTable.unitsPerEm))
		  cacheD.CapHeight= Round(sCapHeight* 1000/ headTable.unitsPerEm)
		  cacheD.Ascent= Round(sTypoAscender* 1000/ headTable.unitsPerEm)
		  cacheD.Descent= Round(sTypoDescender* 1000/ headTable.unitsPerEm)
		  cacheD.isFixedPitch= postTable.IsFixedPitch
		  CacheFontInfoDescriptor.Append cacheD
		  
		  CacheFontInfoFontFile.Append New DBReportPDFFontFile(Nil, f) //font file
		  
		  Dim cacheFW As New DBReportPDFFontWidths
		  If CharacterWidths.Ubound> -1 Then
		    For i As Integer= 0 To 254
		      cacheFW.Widths.Append CharacterWidths(i)
		    Next
		  End
		  CacheFontInfoWidths.Append cacheFW
		  
		  ReadStream.Close
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SetFontInfo(baseFont As String, bold As Boolean, italic As Boolean)
		  Dim nFonts As Integer= CacheFontInfoDescriptor.Ubound
		  
		  Dim found As Boolean
		  
		  For i As Integer= 0 To nFonts
		    Dim cacheD As New DBReportPDFFontDescriptor
		    cacheD= CacheFontInfoDescriptor(i)
		    If cacheD.FontFamily.InStr(baseFont)> 0 Then
		      If bold And italic Then
		        If cacheD.isBold And cacheD.isItalic Then found= True
		      ElseIf bold Then
		        If cacheD.isBold Then found= True
		      ElseIf italic Then
		        If cacheD.isItalic Then found= True
		      Else
		        found= True
		      End
		      
		      If found Then
		        FontDescriptor= New DBReportPDFFontDescriptor(FileRoot)
		        FontDescriptor.FontName= cacheD.FontName
		        FontDescriptor.FontFamily= cacheD.FontFamily
		        'FontDescriptor.FontNameOS= baseFont
		        FontDescriptor.isBold= cacheD.isBold
		        FontDescriptor.isItalic= cacheD.isItalic
		        FontDescriptor.FontBBox= New DBReportPDFRect(cacheD.FontBBox.Left, cacheD.FontBBox.Top, _
		        cacheD.FontBBox.Width, cacheD.FontBBox.Height)
		        FontDescriptor.CapHeight= cacheD.CapHeight
		        FontDescriptor.Ascent= cacheD.Ascent
		        FontDescriptor.Descent= cacheD.Descent
		        FontDescriptor.isFixedPitch= cacheD.isFixedPitch
		        
		        Dim cacheFF As DBReportPDFFontFile= CacheFontInfoFontFile(i)
		        If FileRoot.CacheGetFontFileHasKey(cacheFF.FileFont.Name) Then
		          FontDescriptor.FontFile= FileRoot.CacheGetFontFile(cacheFF.FileFont.Name)
		        Else
		          FontDescriptor.FontFile= New DBReportPDFFontFile(FileRoot, cacheFF.FileFont)
		          FileRoot.CacheSetFontFile cacheFF.FileFont.Name, FontDescriptor.FontFile
		        End
		        
		        Dim cacheFW As DBReportPDFFontWidths= CacheFontInfoWidths(i)
		        FontWidths= New DBReportPDFFontWidths(FileRoot)
		        FontWidths.Widths= cacheFW.Widths
		        
		        Dim key As String= GetCacheKey(baseFont, bold, italic)
		        FileRoot.CacheSetFontDescriptor key, FontDescriptor
		        FileRoot.CacheSetFontWidths key, FontWidths
		        
		        Me.BaseFont= FontDescriptor.FontName //change orignal name to name of file
		        mFontFound= True
		        Exit For
		      End
		    End
		  Next
		  
		  If Not found Then //search for same name
		    For i As Integer= 0 To nFonts- 1
		      Dim cacheD As New DBReportPDFFontDescriptor
		      cacheD= CacheFontInfoDescriptor(i)
		      If cacheD.FontFamily.InStr(baseFont)> 0 Then
		        FontDescriptor= New DBReportPDFFontDescriptor(FileRoot)
		        FontDescriptor.FontName= cacheD.FontName
		        FontDescriptor.FontFamily= cacheD.FontFamily
		        'FontDescriptor.FontNameOS= baseFont
		        FontDescriptor.isBold= cacheD.isBold
		        FontDescriptor.isItalic= cacheD.isItalic
		        FontDescriptor.FontBBox= New DBReportPDFRect(cacheD.FontBBox.Left, cacheD.FontBBox.Top, _
		        cacheD.FontBBox.Width, cacheD.FontBBox.Height)
		        FontDescriptor.CapHeight= cacheD.CapHeight
		        FontDescriptor.Ascent= cacheD.Ascent
		        FontDescriptor.Descent= cacheD.Descent
		        FontDescriptor.isFixedPitch= cacheD.isFixedPitch
		        
		        Dim cacheFF As DBReportPDFFontFile= CacheFontInfoFontFile(i)
		        If FileRoot.CacheGetFontFileHasKey(cacheFF.FileFont.Name) Then
		          FontDescriptor.FontFile= FileRoot.CacheGetFontFile(cacheFF.FileFont.Name)
		        Else
		          FontDescriptor.FontFile= New DBReportPDFFontFile(FileRoot, cacheFF.FileFont)
		          FileRoot.CacheSetFontFile cacheFF.FileFont.Name, FontDescriptor.FontFile
		        End
		        
		        Dim cacheFW As DBReportPDFFontWidths= CacheFontInfoWidths(i)
		        FontWidths= New DBReportPDFFontWidths(FileRoot)
		        FontWidths.Widths= cacheFW.Widths
		        
		        Dim key As String= GetCacheKey(baseFont, bold, italic)
		        FileRoot.CacheSetFontDescriptor key, FontDescriptor
		        FileRoot.CacheSetFontWidths key, FontWidths
		        
		        Me.BaseFont= FontDescriptor.FontName //change orignal name to name of file
		        mFontFound= True
		      End
		    Next
		  End
		  
		  If Not mFontFound Then Me.BaseFont= GetCacheKey(baseFont, bold, italic)
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
		FirstChar As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		FontDescriptor As DBReportPDFFontDescriptor
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
