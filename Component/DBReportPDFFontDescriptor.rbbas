#tag Class
Protected Class DBReportPDFFontDescriptor
Inherits DBReportPDFObject
	#tag Method, Flags = &h21
		Private Function ConstructFlags() As String
		  Dim i As Integer
		  
		  if isFixedPitch then i=i+1
		  if isSerif then i=i+2
		  if isSymbolic then i=i+4 else i=i+32
		  if isScript then i=i+8
		  if isItalic then i=i+64
		  if isAllCap then i=i+65536
		  if isSmallCap then i=i+131072
		  if isForceBold then i=i+262144
		  
		  Return Str(i)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(root As DBReportPDF)
		  If root<> Nil Then
		    FileRoot= root
		    root.Objects.Append Me
		  End
		  
		  Type="FontDescriptor"
		  
		  FontBBox= New DBReportPDFRect(0, 0, 0, 0)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetData() As String
		  Dim s As String
		  
		  s= s+ "<< /Type /"+ Type+" /FontName /"+ FontName+ " /FontFamily /"+ FontFamily+ " /Flags "+ ConstructFlags
		  s= s+ " /FontBBox "+ FontBBox.DataStream+ " /MissingWidth 255 /StemV "+ Fs(StemV)+ " /StemH "+ Fs(stemH)
		  s= s+ " /CapHeight "+ Fs(CapHeight)+ " /XHeight "+ Fs(xHeight)+ " /FontFile2 "+ FontFile.IndirectReference
		  s= s+ " /Ascent "+ Fs(Ascent)+ " /Descent "+ Fs(Descent)+ " /Leading "+ Fs(Leading)
		  s= s+ " /MaxWidth "+ Fs(MaxWidth)+ " /AvgWidth "+ Fs(AvgWidth)+ " /ItalicAngle "+ Fs(ItalicAngle)
		  s= s+ " >>"
		  
		  Return s
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		Ascent As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		AvgWidth As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		CapHeight As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		Descent As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		FileRoot As DBReportPDF
	#tag EndProperty

	#tag Property, Flags = &h0
		FontBBox As DBReportPDFRect
	#tag EndProperty

	#tag Property, Flags = &h0
		FontFamily As String
	#tag EndProperty

	#tag Property, Flags = &h0
		FontFile As DBReportPDFFontFile
	#tag EndProperty

	#tag Property, Flags = &h0
		FontName As String
	#tag EndProperty

	#tag Property, Flags = &h0
		FontNameOS As String
	#tag EndProperty

	#tag Property, Flags = &h0
		isAllCap As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		isBold As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		isFixedPitch As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		isForceBold As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		isItalic As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		isScript As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		isSerif As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		isSmallCap As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		isSymbolic As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		ItalicAngle As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		Leading As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		MaxWidth As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		stemH As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		StemV As Double = 80
	#tag EndProperty

	#tag Property, Flags = &h0
		xHeight As Double
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Ascent"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AvgWidth"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ByteOffset"
			Group="Behavior"
			Type="Integer"
			InheritedFrom="DBReportPDFObject"
		#tag EndViewProperty
		#tag ViewProperty
			Name="CapHeight"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Descent"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FontFamily"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FontName"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FontNameOS"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
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
			Name="isAllCap"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="isBold"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="isFixedPitch"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="isForceBold"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="isItalic"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="isScript"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="isSerif"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="isSmallCap"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="isSymbolic"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ItalicAngle"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Leading"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="MaxWidth"
			Group="Behavior"
			Type="Double"
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
			Name="stemH"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="StemV"
			Group="Behavior"
			InitialValue="80"
			Type="Double"
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
		#tag ViewProperty
			Name="xHeight"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
