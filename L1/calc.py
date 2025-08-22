#!/usr/bin/env python3

import math
import toml

def format_with_uncertainty(mean, uncertainty):
    return f"{mean:.15g}+-{uncertainty:.15g}"

def load_input_data():
    with open('input.toml', 'r') as f:
        return toml.load(f)

def calculate_pi_absolute_errors():
    errors = []

    for i in range(2, 15):
        exponent = -i
        pi_approx = math.floor(math.pi * 10**(-exponent)) / 10**(-exponent)
        absolute_error = math.pi - pi_approx
        errors.append({
            'round': i,
            'absolute_error': absolute_error
        })

    return errors

def calculate_pi_relative_errors():
    pi_real = math.pi
    errors = []

    for i in range(2, 10):
        pi_approx = math.floor(pi_real * 10**i) / 10**i
        absolute_error = 10**(-i)
        relative_error = absolute_error / pi_approx if pi_approx != 0 else 0
        errors.append({
            'round': i,
            'absolute_error': absolute_error,
            'relative_error': relative_error
        })

    return errors

def calculate_theta_analysis():
    analysis = []

    for theta_degrees in range(1, 49):
        theta_radians = theta_degrees * math.pi / 180.0
        sin_theta = math.sin(theta_radians)
        relative_error = theta_radians / sin_theta - 1 if sin_theta != 0 else 0
        relative_error_percent = relative_error * 100
        analysis.append({
            'theta_degrees': theta_degrees,
            'theta_radians': theta_radians,
            'sin_theta': sin_theta,
            'relative_error': relative_error,
            'relative_error_percent': relative_error_percent
        })

    return analysis

def calculate_part4_propagation(diameter_mean, diameter_uncertainty, height_mean, height_uncertainty, pi_value, pi_uncertainty):
    import math

    # Perimeter calculations: P = 2(d + h)
    perimeter = 2 * (diameter_mean + height_mean)
    perimeter_linear_error = 2 * (diameter_uncertainty + height_uncertainty)
    perimeter_quadratic_error = 2 * math.sqrt(diameter_uncertainty**2 + height_uncertainty**2)

    # Area calculations: A = d * h
    area = diameter_mean * height_mean
    area_linear_error = height_mean * diameter_uncertainty + diameter_mean * height_uncertainty
    area_quadratic_error = math.sqrt((height_mean * diameter_uncertainty)**2 + (diameter_mean * height_uncertainty)**2)

    # Volume calculations: V = π * d² * h / 4
    volume = pi_value * diameter_mean**2 * height_mean / 4
    # Partial derivatives: ∂V/∂π = d²*h/4, ∂V/∂d = π*d*h/2, ∂V/∂h = π*d²/4
    dV_dpi = diameter_mean**2 * height_mean / 4
    dV_dd = pi_value * diameter_mean * height_mean / 2
    dV_dh = pi_value * diameter_mean**2 / 4
    volume_linear_error = abs(dV_dpi) * pi_uncertainty + abs(dV_dd) * diameter_uncertainty + abs(dV_dh) * height_uncertainty
    volume_quadratic_error = math.sqrt((dV_dpi * pi_uncertainty)**2 + (dV_dd * diameter_uncertainty)**2 + (dV_dh * height_uncertainty)**2)

    return {
        'perimeter_value': perimeter,
        'perimeter_linear_error': perimeter_linear_error,
        'perimeter_quadratic_error': perimeter_quadratic_error,
        'area_value': area,
        'area_linear_error': area_linear_error,
        'area_quadratic_error': area_quadratic_error,
        'volume_value': volume,
        'volume_linear_error': volume_linear_error,
        'volume_quadratic_error': volume_quadratic_error,
        'volume_partial_pi': dV_dpi,
        'volume_partial_d': dV_dd,
        'volume_partial_h': dV_dh
    }

def calculate_measurement_statistics(measurements, instrument_precision):
    mean = sum(measurements) / len(measurements)
    deviations = [measurement - mean for measurement in measurements]
    deviations_squared = [deviation**2 for deviation in deviations]
    variance = sum(deviations_squared) / len(measurements)
    standard_error = math.sqrt(variance / (len(measurements) - 1))
    uncertainty = max(standard_error, instrument_precision)

    data = []
    for measurement, deviation, deviation_squared in zip(measurements, deviations, deviations_squared):
        data.append({
            'measured': measurement,
            'deviation': deviation,
            'deviation_squared': deviation_squared
        })

    return {
        'mean': mean,
        'variance': variance,
        'standard_error': standard_error,
        'uncertainty': uncertainty,
        'data': data
    }

def save_output_data(output):
    with open('output.toml', 'w') as f:
        toml.dump(output, f)

def main():
    data = load_input_data()

    output = {
        'title': data['title'],
        'subtitle': data['subtitle'],
        'caliper_precision': data['caliper_precision'],
        'micrometer_precision': data['micrometer_precision'],
        'pi_absolute_errors': calculate_pi_absolute_errors(),
        'pi_relative_errors': calculate_pi_relative_errors(),
        'theta_analysis': calculate_theta_analysis()
    }

    height_stats = calculate_measurement_statistics(data['height'], data['caliper_precision'])
    output['height_mean'] = height_stats['mean']
    output['height_variance'] = height_stats['variance']
    output['height_standard_error'] = height_stats['standard_error']
    output['height_uncertainty'] = height_stats['uncertainty']
    output['height_data'] = height_stats['data']
    output['height_formatted'] = format_with_uncertainty(height_stats['mean'], height_stats['uncertainty'])
    output['height_result'] = format_with_uncertainty(height_stats['mean'], height_stats['uncertainty'])

    diameter_stats = calculate_measurement_statistics(data['diameter'], data['micrometer_precision'])
    output['diameter_mean'] = diameter_stats['mean']
    output['diameter_variance'] = diameter_stats['variance']
    output['diameter_standard_error'] = diameter_stats['standard_error']
    output['diameter_uncertainty'] = diameter_stats['uncertainty']
    output['diameter_data'] = diameter_stats['data']
    output['diameter_formatted'] = format_with_uncertainty(diameter_stats['mean'], diameter_stats['uncertainty'])
    output['diameter_result'] = format_with_uncertainty(diameter_stats['mean'], diameter_stats['uncertainty'])

    # Error propagation calculations
    pi_value = math.pi  # Using π approximation from Activity 1
    pi_uncertainty = 0.001  # Uncertainty from 2 decimal places approximation
    part4_results = calculate_part4_propagation(
        diameter_stats['mean'],
        diameter_stats['uncertainty'],
        height_stats['mean'],
        height_stats['uncertainty'],
        pi_value,
        pi_uncertainty
    )
    
    # Flatten part4 results
    output.update(part4_results)
    output['pi_value'] = pi_value
    output['pi_uncertainty'] = pi_uncertainty
    output['pi_result'] = format_with_uncertainty(pi_value, pi_uncertainty)

    # Add pre-formatted uncertainty strings
    output['perimeter_linear_result'] = format_with_uncertainty(part4_results['perimeter_value'], part4_results['perimeter_linear_error'])
    output['perimeter_quadratic_result'] = format_with_uncertainty(part4_results['perimeter_value'], part4_results['perimeter_quadratic_error'])
    output['area_linear_result_mm'] = format_with_uncertainty(part4_results['area_value'], part4_results['area_linear_error'])
    output['area_quadratic_result_mm'] = format_with_uncertainty(part4_results['area_value'], part4_results['area_quadratic_error'])
    output['area_linear_result_cm'] = format_with_uncertainty(part4_results['area_value'] / 100, part4_results['area_linear_error'] / 100)
    output['area_quadratic_result_cm'] = format_with_uncertainty(part4_results['area_value'] / 100, part4_results['area_quadratic_error'] / 100)
    output['volume_linear_result_mm'] = format_with_uncertainty(part4_results['volume_value'], part4_results['volume_linear_error'])
    output['volume_quadratic_result_mm'] = format_with_uncertainty(part4_results['volume_value'], part4_results['volume_quadratic_error'])
    output['volume_linear_result_cm'] = format_with_uncertainty(part4_results['volume_value'] / 1000, part4_results['volume_linear_error'] / 1000)
    output['volume_quadratic_result_cm'] = format_with_uncertainty(part4_results['volume_value'] / 1000, part4_results['volume_quadratic_error'] / 1000)

    save_output_data(output)

if __name__ == "__main__":
    main()
