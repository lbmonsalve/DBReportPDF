#tag Class
Protected Class DBReportPDFContents
Inherits DBReportPDFObject
	#tag Method, Flags = &h0
		Sub AddFilledOval(x as Double, y as Double, width as Double, height as Double, penWidth as Double, foreColor as color)
		  Dim s As String
		  
		  Dim wx,wy,wnwx,wnwy,nnwx,nnwy,nx,ny,nnex,nney,enex,eney,ex,ey,esex,esey,ssex,ssey,sx,sy,sswx,sswy,wswx,wswy as Double
		  
		  wnwx=x
		  wx=x
		  wswx=x
		  
		  nnwx=x+(width/4)
		  sswx=x+(width/4)
		  
		  nx=x+(width/2)
		  sx=x+(width/2)
		  
		  nnex=x+(3*(width/4))
		  ssex=x+(3*(width/4))
		  
		  enex=x+width
		  ex=x+width
		  esex=x+width
		  
		  sswy=y
		  sy=y
		  ssey=y
		  
		  wswy=y+(height/4)
		  esey=y+(height/4)
		  
		  wy=y+(height/2)
		  ey=y+(height/2)
		  
		  wnwy=y+(3*(height/4))
		  eney=y+(3*(height/4))
		  
		  nnwy=y+height
		  ny=y+height
		  nney=y+height
		  
		  s=s+getRGBTriplet(foreColor)+" RG " // set stroking color
		  s=s+getRGBTriplet(foreColor)+" rg"+ CR // set non-stroking color
		  s=s+fs(penWidth)+" w 0 j " // set pen width and miter join
		  s=s+fs(wx)+" "+fs(wy)+" m "+fs(wnwx)+" "+fs(wnwy)+" "+fs(nnwx)+" "+fs(nnwy)+" "+fs(nx)+" "+fs(ny)+" c " //top left
		  s=s+fs(nnex)+" "+fs(nney)+" "+fs(enex)+" "+fs(eney)+" "+fs(ex)+" "+fs(ey)+" c " //top right
		  s=s+fs(esex)+" "+fs(esey)+" "+fs(ssex)+" "+fs(ssey)+" "+fs(sx)+" "+fs(sy)+" c " //bottom right
		  s=s+fs(sswx)+" "+fs(sswy)+" "+fs(wswx)+" "+fs(wswy)+" "+fs(wx)+" "+fs(wy)+" c b"+ CR //bottom left; then fill and stroke
		  
		  Objects.append s
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddFilledPolygon(points() As Double, penWidth As Double, foreColor As Color)
		  Dim s As String
		  Dim i,n As Integer
		  
		  n= Ubound(points)
		  If n> 3 Then
		    s= s+ getRGBTriplet(foreColor)+ " RG " // set stroking color
		    s= s+ getRGBTriplet(foreColor)+ " rg"+ CR // set non-stroking color
		    s= s+ fs(penWidth)+ " w 0 j " // set pen width and miter join
		    
		    s= s+ fs(points(0))+ " "+ fs(points(1))+ " m " // first point
		    For i= 2 To n Step 2
		      s= s+ fs(points(i))+ " "+ fs(points(i+ 1))+ " l " // each point in the polygon
		    Next
		    s= s+ "b"+ CR // fill and stroke
		    
		    Objects.Append s
		  End
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddFilledRect(x as Double, y as Double, width as Double, height as Double, penWidth as Double, foreColor as color)
		  Dim s as string
		  
		  s=s+getRGBTriplet(foreColor)+" RG " // set stroking color
		  s=s+getRGBTriplet(foreColor)+" rg"+ CR // set non-stroking color
		  s=s+fs(penWidth)+" w 0 j " // set pen width and miter join
		  s=s+fs(x)+" "+fs(y)+" m "+fs(x+width)+" "+fs(y)+" l "+fs(x+width)+" "+fs(y+height)+" l " // bottom and right sides
		  s=s+fs(x)+" "+fs(y+height)+" l "+fs(x)+" "+fs(y)+" l b"+ CR // top and left sides; then fill and stroke
		  
		  objects.append s
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddFilledRoundRect(x as Double, y as Double, width as Double, height as Double, ovalWidth as Double, ovalHeight as Double, penWidth as Double, foreColor as color)
		  Dim s as string
		  
		  s=s+getRGBTriplet(foreColor)+" RG " // set color
		  s=s+getRGBTriplet(foreColor)+" rg"+ CR // set non-stroking color
		  s=s+fs(penWidth)+" w 0 j " // set pen width and miter join
		  s=s+fs(x)+" "+fs(y+height-(ovalHeight/2))+" m "+fs(x)+" "+fs(y+height-(ovalHeight/4))+" "+fs(x+(ovalWidth/4))+" "+fs(y+height)+" "+fs(x+(ovalWidth/2))+" "+fs(y+height)+" c " //top left
		  s=s+fs(x+width-(ovalWidth/2))+" "+fs(y+height)+" l " //top
		  s=s+fs(x+width-(ovalWidth/4))+" "+fs(y+height)+" "+fs(x+width)+" "+fs(y+height-(ovalHeight/4))+" "+fs(x+width)+" "+fs(y+height-(ovalHeight/2))+" c " //top right
		  s=s+fs(x+width)+" "+fs(y+(ovalHeight/2))+" l " // right
		  s=s+fs(x+width)+" "+fs(y+(ovalHeight/4))+" "+fs(x+width-(ovalWidth/4))+" "+fs(y)+" "+fs(x+width-(ovalWidth/2))+" "+fs(y)+" c " //bottom right
		  s=s+fs(x+(ovalWidth/2))+" "+fs(y)+" l " //bottom
		  s=s+fs(x+(ovalWidth/4))+" "+fs(y)+" "+fs(x)+" "+fs(y+(ovalHeight/4))+" "+fs(x)+" "+fs(y+(ovalWidth/2))+" c " //bottom left
		  s=s+fs(x)+" "+fs(y+height-(ovalHeight/2))+" l b"+ CR // left; then fill and stroke
		  
		  objects.append s
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddImage(imageRef as string, x as Double, y as Double, width as Double, height as Double)
		  Dim s As String
		  
		  s= s+ "q"+ CR // save graphics state
		  s= s+ fs(width)+ " 0 0 "+ fs(height)+ " "+ fs(x)+ " "+ fs(y)+ " cm"+ CR // translate and scale
		  s= s+ "/"+ imageRef+ " Do"+ CR // paint image
		  s= s+ "Q"+ CR
		  
		  objects.append s
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddLine(x1 as Double, y1 as Double, x2 as Double, y2 as Double, penWidth as Double, foreColor as color)
		  Dim s As String
		  
		  s= s+ getRGBTriplet(foreColor)+ " RG"+ CR // set color
		  s= s+ fs(penWidth)+ " w 0 J " // set pen width and butt cap
		  s= s+ fs(x1)+ " "+ fs(y1)+ " m "+ fs(x2)+ " "+ fs(y2)+ " l s"+ CR // line from x1,y1 to x2,y2; then stroke
		  
		  Objects.Append s
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddOval(x as Double, y as Double, width as Double, height as Double, penWidth as Double, foreColor as color)
		  Dim s As String
		  
		  Dim wx,wy,wnwx,wnwy,nnwx,nnwy,nx,ny,nnex,nney,enex,eney,ex,ey,esex,esey,ssex,ssey,sx,sy,sswx,sswy,wswx,wswy as Double
		  
		  wnwx=x
		  wx=x
		  wswx=x
		  
		  nnwx=x+(width/4)
		  sswx=x+(width/4)
		  
		  nx=x+(width/2)
		  sx=x+(width/2)
		  
		  nnex=x+(3*(width/4))
		  ssex=x+(3*(width/4))
		  
		  enex=x+width
		  ex=x+width
		  esex=x+width
		  
		  sswy=y
		  sy=y
		  ssey=y
		  
		  wswy=y+(height/4)
		  esey=y+(height/4)
		  
		  wy=y+(height/2)
		  ey=y+(height/2)
		  
		  wnwy=y+(3*(height/4))
		  eney=y+(3*(height/4))
		  
		  nnwy=y+height
		  ny=y+height
		  nney=y+height
		  
		  s=s+getRGBTriplet(foreColor)+" RG"+ CR // set color
		  s=s+fs(penWidth)+" w 0 j " // set pen width and miter join
		  s=s+fs(wx)+" "+fs(wy)+" m "+fs(wnwx)+" "+fs(wnwy)+" "+fs(nnwx)+" "+fs(nnwy)+" "+fs(nx)+" "+fs(ny)+" c " //top left
		  s=s+fs(nnex)+" "+fs(nney)+" "+fs(enex)+" "+fs(eney)+" "+fs(ex)+" "+fs(ey)+" c " //top right
		  s=s+fs(esex)+" "+fs(esey)+" "+fs(ssex)+" "+fs(ssey)+" "+fs(sx)+" "+fs(sy)+" c " //bottom right
		  s=s+fs(sswx)+" "+fs(sswy)+" "+fs(wswx)+" "+fs(wswy)+" "+fs(wx)+" "+fs(wy)+" c s"+ CR //bottom left; then stroke
		  
		  Objects.Append s
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddPolygon(points() As Double, penWidth As Double, foreColor As Color)
		  Dim s As String
		  Dim i,n As Integer
		  
		  n= Ubound(points)
		  If n> 3 Then
		    s= s+ getRGBTriplet(foreColor)+ " RG"+ CR // set color
		    s= s+ fs(penWidth)+ " w 0 j " // set pen width and miter join
		    
		    s= s+ fs(points(0))+ " "+ fs(points(1))+ " m " // first point
		    For i= 2 To n Step 2
		      s= s+ fs(points(i))+ " "+ fs(points(i+ 1))+ " l " // each point in the polygon
		    Next
		    s= s+ "s"+ CR // stroke
		    
		    Objects.Append s
		    
		  End
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddRect(x as Double, y as Double, width as Double, height as Double, penWidth as Double, foreColor as color)
		  Dim s As String
		  
		  s= s+ getRGBTriplet(foreColor)+ " RG"+ CR // set color
		  s= s+ fs(penWidth)+ " w 0 j " // set pen width and miter join
		  s= s+ fs(x)+ " "+ fs(y)+ " m "+ fs(x+ width)+ " "+ fs(y)+ " l "+ fs(x+ width)+ " "+ fs(y- height)+ " l " // bottom right sides
		  s= s+ fs(x)+ " "+ fs(y- height)+ " l "+ fs(x)+ " "+ fs(y)+ " l s"+ CR // top and left sides; then stroke
		  
		  Objects.Append s
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddRoundRect(x as Double, y as Double, width as Double, height as Double, ovalWidth as Double, ovalHeight as Double, penWidth as Double, foreColor as color)
		  dim s as string
		  
		  s=s+getRGBTriplet(foreColor)+" RG"+ CR // set color
		  s=s+fs(penWidth)+" w 0 j " // set pen width and miter join
		  s=s+fs(x)+" "+fs(y-height+(ovalHeight/2))+" m "+fs(x)+" "+fs(y-height+(ovalHeight/4))+" "+fs(x+(ovalWidth/4))+" "+fs(y-height)+" "+fs(x+(ovalWidth/2))+" "+fs(y-height)+" c " //top left
		  s=s+fs(x+width-(ovalWidth/2))+" "+fs(y-height)+" l " //top
		  s=s+fs(x+width-(ovalWidth/4))+" "+fs(y-height)+" "+fs(x+width)+" "+fs(y-height+(ovalHeight/4))+" "+fs(x+width)+" "+fs(y-height+(ovalHeight/2))+" c " //top right
		  s=s+fs(x+width)+" "+fs(y-(ovalHeight/2))+" l " // right
		  s=s+fs(x+width)+" "+fs(y-(ovalHeight/4))+" "+fs(x+width-(ovalWidth/4))+" "+fs(y)+" "+fs(x+width-(ovalWidth/2))+" "+fs(y)+" c " //bottom right
		  s=s+fs(x+(ovalWidth/2))+" "+fs(y)+" l " //bottom
		  s=s+fs(x+(ovalWidth/4))+" "+fs(y)+" "+fs(x)+" "+fs(y-(ovalHeight/4))+" "+fs(x)+" "+fs(y-(ovalWidth/2))+" c " //bottom left
		  s=s+fs(x)+" "+fs(y-height+(ovalHeight/2))+" l s"+ CR // left; then stroke
		  
		  objects.append s
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddText(whichText as string, x as Double, y as Double, fontRef as string, fontSize as Double, foreColor as color)
		  Dim s As String
		  
		  s= s+ "BT"+ CR // begin text block
		  s= s+ "/"+ fontRef+ " "+ fs(fontSize)+ " Tf"+ CR
		  s= s+ "1 0 0 1 "+ fs(x)+ " "+ fs(y)+ " Tm"+ CR
		  s= s+ getRGBTriplet(foreColor)+ " RG"+ CR // set stroking color
		  s= s+ getRGBTriplet(foreColor)+ " rg"+ CR // set non-stroking color
		  s= s+ FormatLiteralString(whichText)+ " Tj"+ CR
		  s= s+ "ET"+ CR
		  
		  Objects.Append s
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function CompileContentsStream() As string
		  Dim i,n As Integer
		  Dim s As String
		  
		  n= Ubound(Objects)
		  If n> -1 Then
		    For i= 0 to n
		      s= s+ Objects(i)
		    Next
		  End
		  
		  If FileRoot.Compression Then s= DBReportPDF.zlibCompress(s)
		  
		  Return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor(root As DBReportPDF)
		  FileRoot= root
		  root.Objects.Append Me
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetData() As String
		  Dim s, filter As String
		  
		  If FileRoot.Compression Then filter= "/Filter /FlateDecode "
		  
		  s= CompileContentsStream
		  
		  Return "<< "+ filter+ "/Length "+ str(len(s))+ " >> "+ "stream"+ CR+ s+ CR+ "endstream"+ CR
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetRGBTriplet(whichColor as color) As string
		  return fs(whichColor.Red/ 255)+ " "+ fs(whichColor.Green/ 255)+ " "+ fs(whichColor.Blue/ 255)
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private FileRoot As DBReportPDF
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Objects() As String
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="ByteOffset"
			Group="Behavior"
			Type="Integer"
			InheritedFrom="DBReportPDFObject"
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
