#ifndef MYLIB
#define MYLIB
//重映射
float Remap(float x, float inMin, float inMax, float outMin, float outMax)
{
    return (outMax - outMin) / (inMax - inMin) * (x - inMin) + outMin;
}
float2 Remap(float2 i, float inMin, float inMax, float outMin, float outMax)
{
	float x = Remap(i.x, inMin, inMax, outMin, outMax);
	float y = Remap(i.y, inMin, inMax, outMin, outMax);
    return float2(x, y);
}
float3 Remap(float3 i, float inMin, float inMax, float outMin, float outMax)
{
	float x = Remap(i.x, inMin, inMax, outMin, outMax);
	float y = Remap(i.y, inMin, inMax, outMin, outMax);
	float z = Remap(i.z, inMin, inMax, outMin, outMax);
    return float3(x, y, z);
}
float3 customLerp(float a, float b, float t, float min, float max)
{
	return lerp(a, b, Remap(t, min, max, 0, 1));
}

//RGB与HSV色彩空间的互相转换函数
float3 RGB2HSV(float3 c)
{
    float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    float4 p = lerp(float4(c.bg, K.wz),
					float4(c.gb, K.xy),
					step(c.b, c.g));
    float4 q = lerp(float4(p.xyw, c.r),
					float4(c.r, p.yzx),
					step(p.x, c.r));
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return float3(abs(q.z + (q.w - q.y) / (6.0 * d + e)),
				  d / (q.x + e),
				  q.x);
}
float3 HSV2RGB(float3 c)
{
    float3 rgb = clamp(abs(fmod(c.x * 6.0 + float3(0.0, 4.0, 2.0), 6.0) -3.0) - 1.0,
					   0.0,
					   1.0);
    rgb = rgb * rgb * (3.0 - 2.0 * rgb);//Cubic smoothing
    return c.z * lerp(float3(1,1,1), rgb, c.y);
}
float3 HSV2RYB(float3 c)
{
	//先将RGB映射为RYB
	float hue = fmod(c.x * 6, 6);
    if(hue >= 0 && hue <= 2)
        hue = 0.5 * hue;
    else if(hue > 2 && hue <= 3)
        hue = hue - 1;
    else if(hue > 3 && hue <= 4)
        hue = 1.5 * hue - 2.5;
    else if(hue > 4 && hue <= 5)
        hue = hue - 0.5;
    else if(hue > 5 && hue <= 6)
        hue = 1.5 * hue - 3;
    hue = hue * (1.0 / 6.0);
	//再转换
    float3 rgb = clamp(abs(fmod(hue * 6.0 + float3(0.0, 4.0, 2.0), 6.0) -3.0) - 1.0,
					   0.0,
					   1.0);
    rgb = rgb * rgb * (3.0 - 2.0 * rgb);//Cubic smoothing
    return c.z * lerp(float3(1,1,1), rgb, c.y);
}
//角度Degree与弧度Radian的互相转换函数
float Deg2Rad(float angle)
{
	return angle * UNITY_PI / 180.0f;
}
float Rad2Deg(float rad)
{
	return rad * (180.0f / UNITY_PI);
}
//直角坐标系和极坐标系的互相转换函数
//得到的x为角度，y为半径
//从左开始为-π，逆时针旋转增大，回到左为π
float2 Rect2Polar(float2 uv, float2 centerUV) 
{
    uv = uv - centerUV;//uv沿着左下角变换，需要移动到中间，一般设为(0.5,0.5)
    float theta = atan2(uv.y, uv.x);    // atan()值域[-π/2, π/2]一般不用; atan2()值域[-π, π]
    float r = length(uv);
    return float2(theta, r);
}

//随机数
//返回0到1之间的数
float Hash11(float1 uv)
{
	return frac(sin(dot(uv, 12.9898)) * 43758.5453123);
}
float Hash21(float2 uv)
{
	return frac(sin(dot(uv.xy, float2(12.9898, 78.233))) * 43758.5453123);
}
float Hash31(float3 uv)
{
	return frac(sin(dot(uv.xyz, float3(12.9898, 78.233, 53.539))) * 43758.5453123);
}
float2 Hash22(float2 uv)
{
	uv = float2(dot(uv, float2(127.1, 311.7)),
				dot(uv, float2(269.5, 183.3)));
	return frac(sin(uv) * 43758.5453123);
}
float3 Hash23(float2 uv)
{
	float3 x = float3(uv.xyx);
	x = dot(x, float3(127.1, 311.7, 74.7));
	float3 y = float3(uv.yxx);
	y = dot(y, float3(269.5, 183.3, 246.1));
	float3 z = float3(uv.xyy);
	z = dot(z, float3(113.5, 271.9, 124.6));

	float3 ret = frac(sin(float3(x.x, y.x, z.x)) * 43758.5453123);

	return ret;
}

//噪声	范围都是[0,1]
float ValueNoise1D(float x)
{
	float id = floor(x);
	float u = frac(x);

	float t = smoothstep(0, 1, u);
	//其他t
	//float t = u * u * (3 - 2 * u);

	float y = lerp(Hash11(id), Hash11(id + 1), t);

	return y;
}
float ValueNoise2D(float2 uv)
{
	float2 id = floor(uv);
	float2 fUV = frac(uv);

	float2 t = smoothstep(0, 1, fUV);

	float a = Hash21(id);
	float b = Hash21(id + float2(1, 0));
	float c = Hash21(id + float2(0, 1));
	float d = Hash21(id + float2(1, 1));

	return lerp(lerp(a, b, t.x), lerp(c, d, t.x), t.y);
}
float PerlinNoise2D(float2 uv)
{
	float2 id = floor(uv);
	float2 fUV = frac(uv);

	float2 t = smoothstep(0, 1, fUV);

	float a = dot(Hash22(id) * 2 - 1, fUV);
	float b = dot(Hash22(id + float2(1, 0)) * 2 - 1, fUV - float2(1, 0));
	float c = dot(Hash22(id + float2(0, 1)) * 2 - 1, fUV - float2(0, 1));
	float d = dot(Hash22(id + float2(1, 1)) * 2 - 1, fUV - float2(1, 1));

	return lerp(lerp(a, b, t.x), lerp(c, d, t.x), t.y) * 0.5 + 0.5;
}
float SimplexNoise2D(float2 uv)
{
	float2 p = uv;

	float K1 = 0.366025404; //(sqrt(3)-1)/2
    float K2 = 0.211324865; //(3-sqrt(3))/6

    float2 id = floor(p + (p.x + p.y) * K1);

    float2 a = p - (id - (id.x + id.y) * K2);
    float2 o = (a.x < a.y) ? float2(0.0, 1.0) : float2(1.0, 0.0);
    float2 b = a - o + K2;
    float2 c = a - 1.0 + 2.0 * K2;

    float3 h = max(0.5 - float3(dot(a, a), dot(b, b), dot(c, c)), 0.0);
    float3 n = h * h * h * h * float3(dot(a, Hash22(id) * 2 - 1), dot(b, Hash22(id + o) * 2 - 1), dot(c, Hash22(id + 1.0) * 2 - 1));

    return dot(float3(70.0, 70.0, 70.0), n) * 0.5 + 0.5;
}

//任意轴旋转矩阵
float3x3 AngleAxis3x3(float angle, float3 axis)
{
	float c, s;
	sincos(angle, s, c);

	float t = 1 - c;
	float x = axis.x;
	float y = axis.y;
	float z = axis.z;

	return float3x3(
		t * x * x + c, t * x * y - s * z, t * x * z + s * y,
		t * x * y + s * z, t * y * y + c, t * y * z - s * x,
		t * x * z - s * y, t * y * z + s * x, t * z * z + c
		);
}

//矩阵变换
float2x2 RotateMat(float angle)
{
	angle = Deg2Rad(angle);
	float2x2 retMat = float2x2(cos(-angle), -sin(-angle),
                               sin(-angle), cos(-angle));
	return retMat;
}
float2x2 ScaleMat(float s)
{
	float2x2 retMat = float2x2(1 / s, 0,
                               0, 1 / s);
	return retMat;
}
//对2维(一般为uv)的矩阵应用---由于是给uv用的，所以默认是0到1的uv然后将(0.5,0.5)作为原点
float2 Rotate2D(float2 uv, float angle)
{
	uv -= 0.5;
	float2x2 rM = RotateMat(angle);
	return mul(rM, uv) + 0.5;
}
float2 Scale2D(float2 uv, float s)
{
	uv -= 0.5;
	float2x2 sM = ScaleMat(s);
	return mul(sM, uv) + 0.5;
}
//UV变换
float2 UVTransform(float2 uv, float2 scale, float rotation, float2 offset, float2 pivot)
{
	//轴心点
	uv -= pivot;
	//先缩放
	uv *= scale;
	//再旋转
	uv = float2(uv.x * cos(rotation) -
			    uv.y * sin(rotation),
				uv.x * sin(rotation) +
				uv.y * cos(rotation));
	//最后平移
	uv -= offset;

	return uv;
}
//随机UV变换
float2 RandomUVTransform(float2 uv, float2 scaleMinMax, float2 rotationMinMax, float2 randomSeed)
{
	float3 random = abs(Hash23(randomSeed));

	float2 offset = random.xy;

	float rotation = lerp(rotationMinMax.x, rotationMinMax.y, frac(random.z * 16));
	rotation = Deg2Rad(rotation);
	float2 scale = lerp(scaleMinMax.x, scaleMinMax.y, random.z);

	return UVTransform(uv, scale, rotation, offset, float2(0.5, 0.5));
}
//额外输出反向旋转---用于六边形不重复平铺的法线
float2 RandomUVTransform(float2 uv, float2 scaleMinMax, float2 rotationMinMax, float2 randomSeed, out float invRot)
{
	float3 random = abs(Hash23(randomSeed));

	float2 offset = random.xy;

	float rotation = lerp(rotationMinMax.x, rotationMinMax.y, frac(random.z * 16));
	rotation = Deg2Rad(rotation);
	float2 scale = lerp(scaleMinMax.x, scaleMinMax.y, random.z);

	//额外输出反向旋转值
	invRot = -rotation;

	return UVTransform(uv, scale, rotation, offset, float2(0.5, 0.5));
}

//六边形网格
float3 HexGrid(float2 uv, float2 scale, float exp)
{
	//uv的缩放
	uv *= scale;

	//使用错切矩阵和缩放矩阵修复六边形网格是斜的问题
	float2x2 shearM = float2x2(1, -0.5, 
                               0, 1);
	//上述矩阵相乘等价于:
    //float2 finalUV = float2(uv.x - uv.y * 0.57735, uv.y);
	float2x2 scaleM = float2x2(1, 0,
							   0, 1 / 0.866);
    float2 finalUV = mul(shearM, mul(scaleM, uv));

	//创建棋盘格
	float2 tempUV1 = floor(finalUV);
	float3 checkerBoard = round(frac((((tempUV1.x - tempUV1.y) + float3(0, 1, 2)) * (1.0 / 3.0)) + (5.0 / 3.0) + 0.1));

	//创建梯度图
	float2 tempUV2 = frac(finalUV);
	float gradR = abs((tempUV2.r + tempUV2.g) - 1);
	float t = step(0, (tempUV2.r + tempUV2.g) - 1);
	float2 gradGB = lerp(tempUV2, 1 - tempUV2.yx, t);
	float3 finalGrad = float3(gradR, gradGB);

	//创建六边形灰度图
	float grayR = dot(checkerBoard.zxy, finalGrad);
	float grayG = dot(checkerBoard.yzx, finalGrad);
	float grayB = dot(checkerBoard.xyz, finalGrad);
	float3 finalGray = float3(grayR, grayG, grayB);

	//获得最终六边形
	float3 finalRGB = pow(finalGray, exp);
	finalRGB /= dot(finalRGB, float3(1, 1, 1));

	return finalRGB;
}
float3 HexGrid(float2 uv, float2 scale, float exp, out float2 gridID1, out float2 gridID2, out float2 gridID3)
{
	//uv的缩放
	uv *= scale;

	//使用错切矩阵和缩放矩阵修复六边形网格是斜的问题
	float2x2 shearM = float2x2(1, -0.5, 
                               0, 1);
	//上述矩阵相乘等价于:
    //float2 finalUV = float2(uv.x - uv.y * 0.57735, uv.y);
	float2x2 scaleM = float2x2(1, 0,
							   0, 1 / 0.866);
    float2 finalUV = mul(shearM, mul(scaleM, uv));

	//创建棋盘格
	float2 uvID = floor(finalUV);
	float3 checkerBoard = round(frac((((uvID.x - uvID.y) + float3(0, 1, 2)) * (1.0 / 3.0)) + (5.0 / 3.0) + 0.1));

	//创建梯度图
	float2 tempUV = frac(finalUV);
	float gradR = (tempUV.r + tempUV.g) - 1;
	float triMask = gradR;//用于制作ID图
	gradR = abs(gradR);
	float t = step(0, (tempUV.r + tempUV.g) - 1);
	float2 gradGB = lerp(tempUV, 1 - tempUV.yx, t);
	float3 finalGrad = float3(gradR, gradGB);

	//创建六边形灰度图
	float grayR = dot(checkerBoard.zxy, finalGrad);
	float grayG = dot(checkerBoard.yzx, finalGrad);
	float grayB = dot(checkerBoard.xyz, finalGrad);
	float3 finalGray = float3(grayR, grayG, grayB);

	//获得最终六边形
	float3 finalRGB = pow(finalGray, exp);
	finalRGB /= dot(finalRGB, float3(1, 1, 1));

	//制作ID图
	triMask = step(0, triMask);
	float3 finaltriMask = checkerBoard * triMask;

	gridID1 = uvID + finaltriMask.b + checkerBoard.rg;
	gridID2 = uvID + finaltriMask.g + checkerBoard.br;
	gridID3 = uvID + finaltriMask.r + checkerBoard.gb;

	return finalRGB;
}



//图形绘制	一般来说都是传入[0,1]uv，大部分函数都会映射为[-0.5,0.5]，使其在中心绘制
//1.长方形	需要正常的[0,1]uv
float DrawRect(float2 uv, float2 size, float blur)
{
	//重映射，使size变为输入长宽，符合正常逻辑
	size = Remap(size, 1, 0, 0, 0.5);

	//计算左下黑边以及右上黑边，组合得到中间白长方形
	float2 lbMask = smoothstep(size - blur, size + blur, uv);
    float2 rtMask = smoothstep(size - blur, size + blur, 1 - uv);
    float finalMask = lbMask.x * lbMask.y * rtMask.x * rtMask.y;

	return finalMask;
}
//2.十字		需要正常的[0,1]uv
float DrawCross(float2 uv, float2 size, float blur)
{
	//使用两个长方形获得，只需要将第二个的长宽颠倒即可
	float mask1 = DrawRect(uv, size, blur);
	float mask2 = DrawRect(uv, size.yx, blur);
	float finalMask = mask1 + mask2;

	return finalMask;
}
//3.圆		需要正常的[0,1]uv		注意：函数中已经将中心点已经移到(0.5,0.5)
float DrawCircle(float2 uv, float r, float blur)
{
	//这里将其默认映射到[-0.5,0.5]，也就是原点设置为(0.5,0.5)
	float2 dist = uv - float2(0.5, 0.5);

	//注意：这里dot()要乘4，因为dot()的结果取值范围为[0,0.25]，需要映射为[0,1]
	//因为前面的dist进行的是位移操作，所以这里的倍率是不会有影响的
	float finalMask = 1 - smoothstep(r - (r * blur),
									 r + (r * blur),
									 dot(dist, dist) * 4);
	return finalMask;
}
float DrawCircle(float2 uv, float r, float2 center, float blur)
{
    //uv需要位移，或者说将uv从[0,1]映射到[-center,1-center]
	//这里将其默认映射到[-0.5,0.5]，也就是原点设置为(0.5,0.5)
	float2 dist = uv - center;

	//注意：这里dot()要乘4，因为dot()的结果取值范围为[0,0.25]，需要映射为[0,1]
	//因为前面的dist进行的是位移操作，所以这里的倍率是不会有影响的
	float finalMask = 1 - smoothstep(r - (r * blur),
									 r + (r * blur),
									 dot(dist, dist) * 4);
	return finalMask;
}
//4.多边形	需要正常的[0,1]uv
float DrawPolygon(float2 uv, float n, float size, float rotation, float blur)
{
	//重映射，将uv从[0,1]映射到[-1,1]，此时原点就在中心
	uv = uv * 2 - 1;

	//从直角坐标系转入极坐标系
	float theta = atan2(uv.y, uv.x) + rotation * UNITY_TWO_PI;
	float r = UNITY_TWO_PI / n;

	//计算函数---距离场
	float y = cos(floor(0.5 + theta / r) * r - theta) * length(uv);

	float finalMask = 1 - smoothstep(size - blur, size + blur, y);

	return finalMask;
}
//5.三角形	需要正常的[0,1]uv		默认是左上白右下黑的，可以通过angle获得其他情况
float DrawTriangle(float2 uv, float blur)
{
	float finalMask = smoothstep(uv.x - blur, uv.x + blur, uv.y);
	return finalMask;
}
float DrawTriangle(float2 uv, float angle, float blur)
{
	uv = Rotate2D(uv, angle);
	float finalMask = smoothstep(uv.x - blur, uv.x + blur, uv.y);
	return finalMask;
}
//6.线条
float DrawLine(float2 uv, float width, float blur)
{
	float finalMask = smoothstep(uv.x - width, uv.x, uv.y) - 
					  smoothstep(uv.x, uv.x + width, uv.y);
	//前面生成后就是完全有blur的，再次使用smoothstep()获得真正的控制
	finalMask = smoothstep(0.5 - blur, 0.5 + blur, finalMask);
	return finalMask;
}
float DrawLine(float2 uv, float width, float blur, float angle)
{
	uv = Rotate2D(uv, angle);
	float finalMask = smoothstep(uv.x - width, uv.x, uv.y) - 
					  smoothstep(uv.x, uv.x + width, uv.y);
	//前面生成后就是完全有blur的，再次使用smoothstep()获得真正的控制
	finalMask = smoothstep(0.5 - blur, 0.5 + blur, finalMask);
	return finalMask;
}

//画线---通过uv和一个函数，如：y=x
//注意:uv也需要乘以一样的scale
float plot(float2 uv, float y, float lineWidth, float scale)
{
    return smoothstep(y - 0.02 * lineWidth * scale, y, uv.y) 
            - smoothstep(y, y + 0.02 * lineWidth * scale, uv.y);
}
float plot(float2 uv, float y)
{
    return smoothstep(y - 0.02, y, uv.y) 
            - smoothstep(y, y + 0.02, uv.y);
}
//各类函数
//1.多项式函数
//Blinn-Wyvill Approximation to the Raised Inverted Cosine
float PolyFun1(float x)
{
	float x2 = x * x;
	float x4 = x2 * x2;
	float x6 = x4 * x2;

	float y = (4.0 / 9.0) * x6 - (17.0 / 9.0) * x4 + (22.0 / 9.0) * x2;

	return y;
}
//Double-Cubic Seat
float PolyFun2(float x, float a, float b)
{
	float minA = 0.000001;
	float maxA = 0.999999;
	float minB = 0.0;
	float maxB = 1.0;
	a = min(maxA, max(minA, a));
	b = min(maxB, max(minB, b));

	float y = 0;
	if(x <= a)
	{
		y = b - b * pow(1 - x / a, 3.0);
	}
	else
	{
		y = b + (1 - b) * pow((x - a) / (1 - a), 3.0);
	}
	
	return y;
}
//Double-Cubic Seat with Linear Blend
float PolyFun3(float x, float a, float b)
{
	float minA = 0.000001;
	float maxA = 0.999999;
	float minB = 0.0;
	float maxB = 1.0;
	a = min(maxA, max(minA, a));
	b = min(maxB, max(minB, b));
	b = 1.0 - b;//反向而已，事实上只是滑条从0到1变成了1到0，在这里比较符合操作逻辑

	float y = 0;
	if(x <= a)
	{
		y = b * x + (1 - b) * a * (1 - pow(1 - (x / a), 3.0));
	}
	else
	{
		y = b * x + (1 - b) * (a + (1 - a) * pow((x - a) / (1 - a), 3.0));
	}

	return y;
}
//Double-Odd-Polynomial Seat
float PolyFun4(float x, float a, float b, float n)
{
	float minA = 0.000001;
	float maxA = 0.999999;
	float minB = 0.0;
	float maxB = 1.0;
	a = min(maxA, max(minA, a));
	b = min(maxB, max(minB, b));

	float p = 2 * n + 1;
	float y = 0;
	if(x <= a)
	{
		y = b - b * pow(1 - (x / a), p);
	}
	else
	{
		y = b + (1 - b) * pow((x - a)/ (1 - a), p);
	}

	return y;
}
//Symmetric Double-Polynomial Sigmoids---有bug!!!0.5之后的显示不出来
float PolyFun5(float x, float n)
{
	float y = 0;
	
	if(n % 2 == 0)//指数为偶情况
	{
		if(x <= 0.5)
		{
			y = pow(2.0 * x, n) / 2.0;
		}
		else
		{
			y = 1.0 - pow(2 * (x - 1), n) / 2.0;
		}
	}
	else//指数为奇情况
	{
		if(x <= 0.5)
		{
			y = pow(2.0 * x, n) / 2.0;
		}
		else
		{
			y = 1.0 + pow(2.0 * x - 2.0, n) / 2.0;
		}
	}

	return y;
}
//Quadratic Through a Given Point
//该函数可以穿过(a,b)
//注意:不一定穿过(1,1)
float PolyFun6(float x, float a, float b)
{
	float minA = 0.000001;
	float maxA = 0.999999;
	float minB = 0.0;
	float maxB = 1.0;
	a = min(maxA, max(minA, a));
	b = min(maxB, max(minB, b));

	float A = (1 - b) / (1 - a) - (b - a);
	float B = ((a * a) * A - b) / a;
	float y = A * (x * x) - B * x;
	//y = min(1.0, max(0, y));

	return y;
}
//三次Hermite曲线---cubic Hermite curve
float CubicHermiteCurve(float x)
{
	return x * x * (3 - 2 * x);
}
//五次Hermite曲线---Quintic interpolation curve
float QuinticHermiteCurve(float x)
{
	return x * x * x * (x * (x * 6 - 15) + 10);
}



#endif