Shader "MineselfShader/VFX/8-Billboard/Billboard_ObjectSpace"
{
    Properties
    {
        _MainTex("MainTexture", 2D) = "white"{}
        [HDR]_Color("Color", COLOR) = (1,1,1,1)
    }
    SubShader
    {
        //SubShader Tags
		Tags
        {
            "Queue"="AlphaTest"
            "RenderType"="TransparentCutout"
            "ForceNoShadowCasting"="True"
            "IgnoreProjector"="True"
            "DisableBatching"="True"
        }
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
            sampler2D _MainTex;
            fixed4 _Color;

                
			//��������
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
			
            //�������
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;

                //�۲�ռ��Billboard�ĺ���---����۲�ռ�ԭ�㵽����ռ䶥��λ����Ϊ��Ҫ�Ķ���λ����Ϣ
                float3 oPos = v.vertex;
                float3 pivot = mul(UNITY_MATRIX_MV, float3(0,0,0));
                float3 vertex = normalize(pivot + oPos);//��Ҫ��ӹ�һ��ʹ��Ϊ��λ����
                vertex = mul(vertex, UNITY_MATRIX_MV);

                o.pos = UnityObjectToClipPos(vertex);

                o.uv = v.uv;

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                float4 mainTex = tex2D(_MainTex, i.uv);
                mainTex.rgb *= _Color;

                clip(mainTex.a - 0.5);

                return mainTex;
            }
            ENDCG
        }
    }
    Fallback Off
}