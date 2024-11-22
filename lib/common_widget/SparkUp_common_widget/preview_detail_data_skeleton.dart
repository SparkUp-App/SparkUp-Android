import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

class InfoPreviewCardSkeleton extends StatelessWidget {

  const InfoPreviewCardSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildInfoSection(),
            const SizedBox(height: 5),
            _buildAttributesSection(),
            const SizedBox(height: 20),
            _buildOtherInformation(),
          ],
        ),
      ),
    );
  }


  Widget _buildInfoSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          
            _buildInfoRow(
              icon: Icon(Icons.access_time, color: Colors.blue[700], size: 20),
              text: "",
              isBold: true,
            ),
            const SizedBox(height: 16),
          
            _buildInfoRow(
              icon: Icon(Icons.group, color: Colors.green[700], size: 20),
              text: "",
            ),
            const SizedBox(height: 16),
      
            _buildInfoRow(
              icon: Icon(Icons.location_on, color: Colors.red[700], size: 20),
              text: "",
              maxLines: 2,
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required Widget icon,
    required String text,
    bool isBold = false,
    int maxLines = 1,
  }) {
    return Row(
      children: [
        icon,
        const SizedBox(width: 12),
        Expanded(
          
          child: Skeletonizer(
            effect: const ShimmerEffect(
              baseColor: Colors.white12,
              highlightColor: Colors.white24,
              duration: Duration(seconds: 1),
            ),
            child:Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
              color: Colors.black87,
            ),
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttributesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Additional Information",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: Colors.grey.withOpacity(0.1),
              width: 1,
            ),
          ),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        ),
      ],
    );
  }

  Widget _buildAttributeCard(String key, dynamic value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: Color(0xFFE9765B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              key,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFFE9765B),
                letterSpacing: 0.3,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildAttributeValue(value),
        ],
      ),
    );
  }

  Widget _buildAttributeValue(dynamic value) {
    if (value is String) {
      return Text(
        value,
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[800],
          height: 1.5,
        ),
      );
    } else if (value is List) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var item in value)
            _buildBulletPoint(item.toString()),
        ],
      );
    } else if (value is Map) {
      if (value is Map<String, List<String>>) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var entry in value.entries) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 159, 138).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        entry.key,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 255, 159, 138),
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...entry.value.map((item) => Padding(
                          padding: const EdgeInsets.only(left: 8.0, bottom: 2.0),
                          child: _buildBulletPoint(item),
                        )),
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
          ],
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var entry in value.entries)
              _buildBulletPoint('${entry.key}: ${entry.value}', isMap: true),
          ],
        );
      }
    }
    return const SizedBox.shrink();
  }

  Widget _buildBulletPoint(String text, {bool isMap = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: isMap
                ? Row(
                    children: text.split(': ').map((part) {
                      bool isKey = text.split(': ').first == part;
                      return Text(
                        isKey ? '$part: ' : part,
                        style: TextStyle(
                          fontSize: 16,
                          color: isKey ? Colors.black : Colors.grey[600],
                          height: 1.5,
                          fontWeight: isKey ? FontWeight.w600 : FontWeight.normal,
                        ),
                      );
                    }).toList(),
                  )
                : Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                      height: 1.5,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtherInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Other Information",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: Colors.grey.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Text(
            " ",
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}