Shader "MineselfShader/Basic/16-DepthTexture/DepthTexture"
{
    Properties
    {
        
    }
    SubShader
    {
        //SubShader Tags
		Tags{"Queue"="Geometry+1"}
        Pass
        {
            //Pass Tags
            Tags{}
            //��Ⱦ״̬
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //��������ļ�����ָ��

			
            //��������
            sampler2D _CameraDepthTexture;
                
			//��������
            struct appdata
            {
                float4 vertex : POSITION;
            };
			
            //�������
            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 screenPos : TEXCOORD0;
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.screenPos = ComputeScreenPos(o.pos);

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                float depth01 = tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.screenPos)).r;

                return depth01;
            }
            ENDCG
        }
    }
    Fallback Off
}