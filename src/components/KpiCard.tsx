
import React from 'react';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { ArrowDown, ArrowUp, Minus } from 'lucide-react';
import { cn } from '@/lib/utils';

interface KpiCardProps {
  title: string;
  value: string | number;
  description?: string;
  changeType?: 'increase' | 'decrease' | 'neutral';
  changeValue?: string;
  icon?: React.ReactNode;
  className?: string;
}

const KpiCard: React.FC<KpiCardProps> = ({
  title,
  value,
  description,
  changeType,
  changeValue,
  icon,
  className,
}) => {
  return (
    <Card className={cn("overflow-hidden transition-smooth hover:shadow-md", className)}>
      <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-3 pt-4 px-4">
        <CardTitle className="text-sm font-medium text-muted-foreground">{title}</CardTitle>
        {icon && <div className="text-muted-foreground opacity-70">{icon}</div>}
      </CardHeader>
      <CardContent className="px-4 pb-4">
        <div className="text-3xl font-bold mb-1">{value}</div>
        {(changeType || description) && (
          <div className="flex items-center gap-1.5 text-xs text-muted-foreground mt-1">
            {changeType && changeValue && (
              <>
                <div className={cn(
                  "flex items-center",
                  changeType === 'increase' && "text-green-500",
                  changeType === 'decrease' && "text-red-500",
                  changeType === 'neutral' && "text-muted-foreground"
                )}>
                  {changeType === 'increase' && <ArrowUp className="h-3 w-3 mr-0.5" />}
                  {changeType === 'decrease' && <ArrowDown className="h-3 w-3 mr-0.5" />}
                  {changeType === 'neutral' && <Minus className="h-3 w-3 mr-0.5" />}
                  <span className="font-medium">{changeValue}</span>
                </div>
                {description && <span className="text-muted-foreground/70">•</span>}
              </>
            )}
            {description && <span className="text-muted-foreground/70">{description}</span>}
          </div>
        )}
      </CardContent>
    </Card>
  );
};

export default KpiCard;
