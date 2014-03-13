	<script>
	/*
	   ����˵�������ڴ������ݱ������
	   ����˵����div_name װ�ظñ������Ĳ�
	   rows ������������
	   cols ������������
	   td_width ���Ԫ�Ŀ�
	   td_height ���Ԫ�ĸ�
	   image_path ���Ԫ���ͼƬ·��
	   img_width ���Ԫ���ͼƬ���
	   img_height ���Ԫ���ͼƬ�߶�
	   border ���߿�(��������)
	*/
	function create_datatable(div_name,rows,cols,td_width,td_height,image_path,img_width,img_height,border)
	{
		var table = '<table width="'+ td_width*cols +'" height="'+ td_height*rows +'" cellpadding="0" cellspacing="0" border="'+ border +'">';
		
		for(var i = 0; i < rows; i++)
		{
		   table += '<tr>';

              for(var j = 0; j < cols; j++)
			  {
		   		table += '<td width="'+ td_width +'" height="'+ td_height +'" valign="middle">';
		   		table += '<img id="img' + String(i*cols + j) + '" src="'+ image_path +'" width="'+ img_width +'" height="'+ img_height +'"/></td>';
		   	  }
			  
		   table += '</tr>';
		}
		
		table += '</table>';
		
		document.getElementById(div_name).innerHTML = table;
	}
	
	/*
	   ����˵�������ڴ������ݱ��
	   ����˵����div_name װ�ظ����ݱ��Ĳ�
	   rows ���ݱ�������
	   cols ���ݱ�������
	   td_width ���Ԫ�Ŀ�
	   td_height ���Ԫ�ĸ�
	   image_position ���ݹ���ͼ��λ�� ȡֵΪ left right none
	   img_width ���Ԫ���ͼƬ���
	   img_height ���Ԫ���ͼƬ�߶�
	   offset ����ͼ��λ��ƫ���� image_positionΪrightʱʹ�� ���ڵ�������ͼ������ݵľ���
	   border ���߿�(��������)
	   curr_page ��ǰҳ�����ݶε�ǰҳ
	   list_name �����б�����ݶ��б�
	   image_path ����ͼ���ͼƬ·��
	*/
	function create_data(div_name,rows,cols,td_width,td_height,image_position,img_width,img_height,offset,border,curr_page,list_name,image_path)
	{
		var table = '<table width="'+ td_width*cols +'" height="'+ td_height*rows +'" cellpadding="0" cellspacing="0" border="'+ border +'">';
		
		for(var i = 0; i < rows; i++)
		{
		  table += '<tr>';

		  for(var j = 0; j < cols; j++)
		  {
		        var index = (i*cols + j) + (curr_page*(rows*cols));

                if(image_position == 'left')
				{
					if(list_name[index] != null)
					{
						table += '<td width="'+ td_width +'" height="'+ td_height +'" align="left"><img src="'+ image_path +'" width="'+ img_width +'" height="'+ img_height +'"/>&nbsp;' + list_name[index];
						table += '</td>';
					}
					else
					{
						table += '<td width="'+ td_width +'" height="'+ td_height +'">';
						table += '</td>';
					}					
				}
				else if(image_position == 'right')
				{
					if(list_name[index] != null)
					{
						table += '<td width="'+ (td_width - img_width - offset) +'" height="'+ td_height +'" align="left">' + list_name[index];
						table += '</td><td width="'+ (img_width + offset) +'"><img src="'+ image_path +'" width="'+ img_width +'" height="'+ img_height +'" /></td>';					
					}
					else
					{
						table += '<td width="'+ td_width +'" height="'+ td_height +'" colspan="2" align="center">';
						table += '</td>';						
					}
				}
				else if(image_position == 'none')
				{
					if(list_name[index] != null)
					{
						table += '<td width="'+ td_width +'" height="'+ td_height +'">' + list_name[index];
						table += '</td>';
					}
					else
					{
						table += '<td width="'+ td_width +'" height="'+ td_height +'">';
						table += '</td>';
					}					
				}
		  }
			  
		  table += '</tr>';
		}
		
		table += '</table>';
		
		document.getElementById(div_name).innerHTML = table;
	}
</script>