#!/bin/bash

TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

PROJECT_DIR="$(dirname "$0")/../.."

DELETED_COUNT=$(cd "$PROJECT_DIR" && \
    python manage.py shell -c "
from datetime import timedelta
from django.utils import timezone
from crm.models import Customer
cutoff_date = timezone.now() - timedelta(days=365)
deleted, _ = Customer.objects.filter(order__isnull=True, created_at__lte=cutoff_date).delete()
print(deleted)
")

echo "$TIMESTAMP - Deleted $DELETED_COUNT inactive customers" >> /tmp/customer_cleanup_log.txt
