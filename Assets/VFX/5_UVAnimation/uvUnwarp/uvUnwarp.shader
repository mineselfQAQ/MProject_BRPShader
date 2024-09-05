Shader "MineselfShader/VFX/5-UVAnimation/uvUnwarp"
{
    Properties
    {
        [NoScaleOffset]_MainTex("MainTexture", 2D) = "white"{}
        _Control("Control---0:Common 1:uv", Range(0, 1)) = 0
        [Space(5)]
        _uvX("UV:X", Range(0, 5)) = 1
        _uvY("UV:Y", Range(0, 5)) = 1
        [Space(5)]
        _FresnelPow("FresnelPower", Range(0, 10)) = 3
    }
    SubShader
    {
        //SubShader Tags
		Tags{}
        Pass
        {
            //Pass Tags
            Tags{}
            //��Ⱦ״̬
            Cull Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //��������ļ�����ָ��

			
            //��������
            sampler2D _MainTex;
            float _Control;
            float _uvX;
            float _uvY;
            float _FresnelPow;
                
			//��������
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
                float3 normal : NORMAL;
            };
			
            //�������
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 wNormal : TEXCOORD1;
                float4 wPos : TEXCOORD2;
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;

                //չ���ĺ���---��ͨpos��uvPos���л�
                //��ͨpos��ʵ����v.vertex
                //uvPos�ǽ�uv���룬��Ϊͼ����ʾ����ô������˵������һ��Quad
                //����uv��[0,1]��������Ҫ�������[-0.5,0.5]�ϣ�Ȼ��������Ų���
                v.uv2 -= 0.5;
                v.uv2 = float2(v.uv2.x * _uvX, v.uv2.y * _uvY);
                float4 uvPos = float4(v.uv2, 0, 0);
                float4 pos = lerp(v.vertex, uvPos, _Control);

                o.pos = UnityObjectToClipPos(pos);

                o.uv = v.uv;
                o.wNormal = UnityObjectToWorldNormal(v.normal);
                o.wPos = mul(unity_ObjectToWorld, v.vertex);

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                float4 mainTex = tex2D(_MainTex, i.uv);

                //�����������
                float3 nDir = normalize(i.wNormal);
                float3 lDir = normalize(UnityWorldSpaceLightDir(i.wPos));
                float3 vDir = normalize(UnityWorldSpaceViewDir(i.wPos));

                //�������
                float3 ambient = unity_AmbientSky;
                float diffuse = saturate(dot(lDir, nDir));
                diffuse = lerp(diffuse, 1, _Control);//uvͼģʽ��ֱ�ӲŲ�������
                float fresnel = pow(1 - saturate(dot(nDir, vDir)), _FresnelPow);
                fresnel = lerp(fresnel, 0, _Control);//uvͼģʽ��û�з�����Ч��

                float3 finalRGB = (ambient + diffuse) * mainTex + fresnel;

                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}